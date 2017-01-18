# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'omniauth'
require 'rectify/rspec'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require "capybara/poltergeist"
require 'carrierwave/test/matchers'
require 'aasm/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join('spec/shared_examples/**/*.rb')].each { |share| require share }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ActionDispatch::TestProcess
  config.include Rectify::RSpec::Helpers
  config.include Warden::Test::Helpers
  config.include Support::OmniauthHelper
  config.include Rectify::RSpec::Helpers
  config.include CarrierWave::Test::Matchers
  config.include I18n

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  Capybara.javascript_driver = :poltergeist

  config.use_transactional_fixtures = false

  OmniAuth.config.test_mode = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

end
