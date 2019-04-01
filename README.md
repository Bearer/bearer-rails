# BearerRails

Bearer rails helpers to integrate webhooks

## Installation

Add this line to your rails application's Gemfile:

```ruby
gem 'bearer-rails'
```

## Usage

1. Setup your bearer account on [app.bearer.sh](https://app.bearer.sh/)
2. store bearer config in rails initializer `config/initializer/bearer.rb`

```ruby
# in config/initializers/bearer.rb
    Bearer::Configuration.setup do |config|
      config.api_key = "secret_api_key" # copy and paste the `API key` from https://app.bearer.sh/keys
      config.client_id = "client_id" # copy and paste the `Client Id` from https://app.bearer.sh/keys
      config.secret = "secret" # copy and paste the `Encryption Key` from https://app.beaerer.sh/keys
    end
```

3. setup the routes, and mount BeaerRails::Webhook rack application

```ruby
    # in config/routes.rb
    Rails.application.routes.draw do
      # ...
      mount BearerRails::Webhooks.new, at: '/webhooks'
    end
```

4. define the class which would consume the webhook. Please visit https://app.beaerer.sh to check how to build your own integration. The assumption is you have correctly created integration in Bearer called 'github-attach-pull-request'

```ruby
    # create a class in `app/webhooks/github_attach_pull_request.rb
    class GithubAttachPullRequest
      include BearerRails::Webhook
      # this has to match your integration name https://app.bearer.sh
      integration_handler "4l1c3-github-attach-pull-request"

      def call
        # at this point you have access to the following data: [org_id, integration_id, body]
        consume_webhook_service(body)
      end
    end
```

5. as the classes are lazy loaded in development.rb change the `eager_load` setting to load all the classes on startup (eager loading is set to true in production env anyway)

```ruby
# config/environments/development.rb

Rails.application.configure do
# ...
  config.eager_load = true
# ...
end`
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bearer/bearer-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Bearer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bearer/bearer-rails/blob/master/CODE_OF_CONDUCT.md).
