source 'https://rubygems.org'
ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'

gem 'pg', '~> 0.18'

gem 'puma', '~> 3.0'

gem 'bootstrap-sass', '3.2.0.0'

gem 'sass-rails', '~> 5.0'

gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'

gem 'jquery-rails'

gem 'turbolinks', '~> 5'

gem 'jbuilder', '~> 2.5'

gem 'devise'

gem 'haml-rails'

gem 'simple_form', '~> 3.2', '>= 3.2.1'

gem 'rails-i18n'

gem 'aasm'

gem 'wicked'

gem 'rectify'

gem 'ffaker'

gem 'omniauth'

gem 'omniauth-facebook'

gem 'omniauth-google-oauth2'

gem 'rails_admin'

gem 'rails_admin_aasm'

gem 'cancancan'

gem 'mini_magick'

gem 'carrierwave'

gem 'fog'

gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
gem 'draper', github: 'audionerd/draper', branch: 'rails5'

gem 'credit_card_validations'

gem 'figaro'

gem 'corzinus'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'letter_opener_web'
  gem 'pry'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'wisper-rspec'
  gem 'with_model'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'shoulda-matchers'
end

group :development do
  gem 'haml_lint', require: false
  gem 'listen', '~> 3.0.5'
  gem 'overcommit', require: false
  gem 'rails-erd'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
