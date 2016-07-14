# Sysdig::Cloud

A Ruby client for the Sysdig Cloud REST API. This is essentially a direct Ruby conversion of [Sysdig Cloud's official Python client](https://github.com/draios/python-sdc-client).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sysdig-cloud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sysdig-cloud

## Usage

```ruby
require 'sysdig/cloud'

sysdig = Sysdig::Cloud::Client.new(api_token: your_api_token)

sysdig.get_metrics
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cameronattard/sysdig-cloud.
