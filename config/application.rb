require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Amazon
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework  :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
    config.assets.initialize_on_precompile = false
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end

end
