source 'https://rubygems.org'


gem 'rails', '4.1.0'

gem 'rails-api', '0.3.1'

gem 'attribute-driven', "~> 1.0.2"

gem 'nokogiri', '~> 1.6.5'
gem 'feedjira', '~> 1.6.0'


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

group :development, :production do
  # Use thin as the app server
  gem 'thin'
end

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :test, :development do
  gem "rspec-rails", "~> 2.4"
  gem 'rspec-collection_matchers', '~> 1.1.2'
  gem 'webmock', '~> 1.20.4'
  gem 'simplecov', :require => false
end