# Zzap!

My version of the Raygun tool

## Project Goals

* Pure Ruby
* Rename files as well as placeholders inside files

## Installation

You likely need this gem prior to having an application Gemfile,
so install it:

    $ gem install zzap

## Usage

Zzap'ing a project is super easy! Just provide a target and a Github username/repo.

    $ zzap my_awesome_project username/repo-name

## Templates

Templates are currently just Github projects which subscribe to the following 2 conventions:

1. `app_prototype` will be substituted with the target provided.
2. `AppPrototype` will be substituted with a camel-cased version of the target provided.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adam12/zzap.

I love pull requests! If you fork this project and modify it, please ping me to see
if your changes can be incorporated back into this project.

That said, if your feature idea is nontrivial, you should probably open an issue to
[discuss it](http://www.igvita.com/2011/12/19/dont-push-your-pull-requests/)
before attempting a pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
