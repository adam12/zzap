# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "zzap/version"

Gem::Specification.new do |spec|
  spec.name         = "zzap"
  spec.version      = Zzap::VERSION
  spec.authors      = ["Adam Daniels"]
  spec.email        = ["adam@mediadrive.ca"]

  spec.summary      = %q{Zzap! Zzap!}
  spec.homepage     = "https://github.com/adam12/zzap"
  spec.license      = "MIT"

  spec.files        = Dir["lib/**/*.rb"] + Dir["exe/*"]
  spec.executables  = "zzap"
  spec.bindir       = "exe"

  spec.add_dependency "rubyzip"
  spec.add_development_dependency "rubygems-tasks", "~> 0.2"
  spec.add_development_dependency "rake", "~> 10.0"
end
