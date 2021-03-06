require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsTemplate
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # time zone
    config.time_zone = 'Tokyo'

    # locale
    config.i18n.default_locale = :ja
    config.i18n.fallbacks = [:en]

    # autoload path
    # config.autoload_paths   += %W(#{config.root}/lib)
    # config.eager_load_paths += %W(#{config.root}/lib)

    # change error field html output
    # config.action_view.field_error_proc = proc { |html_tag, instance| "<span class='field_with_errors'>#{html_tag}</span>".html_safe }

    # disable generate assets and helper
    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper      = false

    # helperの自動読み込みをしない
    # config.action_controller.include_all_helpers = false
  end
end
