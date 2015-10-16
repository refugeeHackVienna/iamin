source 'https://rubygems.org'

gem 'rails', '4.2.4'
# Use sqlite3 as the database for Active Record
gem 'pg'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

gem 'sass-rails', '~> 5.0'            # SCSS support for stylesheets in the asset pipeline
gem 'uglifier', '>= 1.3.0'            # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0'        # Coffeescript support in the asset pipeline

gem 'jquery-rails'                    # JQ asset pipeline integration
gem 'jbuilder', '~> 2.0'              # Build JSON APIs with ease.
gem 'sdoc', '~> 0.4.0', group: :doc   # bundle exec rake doc:rails generates the API under doc/api.
gem 'unicorn'                         # Application server

gem "less-rails"                      # Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"         # Twitter Bootstrap integration
gem "simple_form"                     # Form Generation
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true

gem 'devise'                          # Authentication
gem 'devise-bootstrap-views'          # Bootstrap integration for devise
gem 'devise_token_auth'               # Token generation for the API
gem 'omniauth'               # Token generation for the API
gem 'jsonapi-resources'               # API - Generator

gem 'sucker_punch'

# pagination
gem 'kaminari'

gem 'pry'

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem 'byebug'                        # Debugger
  gem 'foreman'
  gem 'guard'
  gem 'guard-livereload'
end

group :development, :test, :staging do
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '~> 2.0'         # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'spring'                        # keeps application running in the background.

  gem 'better_errors'
  gem 'binding_of_caller'
  gem "letter_opener"
end
