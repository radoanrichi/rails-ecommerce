require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module RailsEcommerce
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.active_job.queue_adapter = :sidekiq
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en bn]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
