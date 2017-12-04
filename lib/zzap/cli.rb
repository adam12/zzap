require "pathname"
require "open-uri"
require "zip"
require "net/http"
require "tempfile"

module Zzap
  class CLI
    attr_accessor :target_name, :source

    def initialize(target_name, source)
      @target_name = target_name
      @source = source
    end

    def run
      abort("Target '#{target_name}' already exists! Aborting.") if File.exists?(target_name)

      case source
      when /\Ahttp/
        zipball = Tempfile.new("zzap")

        fetch_source(zipball)
        extract_zipball(zipball)
      when /\A\//
        copy_source
      end

      perform_rename
      perform_sub

    ensure
      if zipball
        zipball.close
        zipball.unlink
      end
    end

    def perform_rename
      # Work from most specific first
      candidates = Dir[target_name + "/**/*app_prototype*"]
        .sort_by { |p| -p.split("/").size }

      candidates.each do |path|
        FileUtils.mv(path, path.sub("app_prototype", target_name))
      end
    end

    def perform_sub
      replacements = {
        "app_prototype" => target_name,
        "AppPrototype" => target_name.split(/[-_]/).map(&:capitalize).join
      }

      pattern = Regexp.union(*replacements.keys)

      Dir[target_name + "/**/*"].each do |path|
        next if File.directory?(path)

        if File.foreach(path).grep(pattern).any?
          File.write(path, File.read(path).gsub(pattern, replacements))
        end
      end
    end

    def fetch_source(zipball)
      warn "Fetching #{source}"
      uri = URI.parse(source)
      zipball.write(uri.read)
      zipball.rewind
    end

    def extract_zipball(zipball)
      Zip::File.open(zipball.path) do |zip_file|
        root = zip_file.find(&:file?).name.split(File::SEPARATOR).shift

        zip_file.each do |entry|
          next unless entry.file?

          full_name = Pathname(target_name) + Pathname(entry.name).sub(root + "/", "")

          FileUtils.mkdir_p(File.dirname(full_name))
          zip_file.extract(entry, full_name)
        end
      end
    end

    def copy_source
      FileUtils.cp_r(source, target_name)
    end

    def self.run(argv)
      target_name = ARGV[0] || abort(usage)
      source = ARGV[1] || abort(usage)

      if github_pattern?(source)
        source = "https://api.github.com/repos/#{source}/zipball"
      end

      new(target_name, source).run
    end

    def self.usage
      <<~EOM
      Usage: zzap target_name source

            target_name             Snake cased folder name that will also be the application name
            source                  Path to app prototype


        Possible source formats:
            user_name/repo_name     Github user and repository
            path                    Local path to folder containing project template
      EOM
    end

    def self.github_pattern?(source)
      return false if source.start_with?("/")
      return false if source.start_with?("http")

      true
    end
  end
end
