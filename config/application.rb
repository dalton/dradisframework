require File.expand_path('../boot', __FILE__)

#ENV['RAILS_ENV'] = 'production'
#RAILS_ENV.replace('production') if defined?(RAILS_ENV)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Dradis
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    if (
      (File.basename($0) == 'rake') &&
      (%w{create drop migrate reset seed}.any? { |task| ARGV.include?("db:#{task}")||ARGV.include?("dradis:#{task}") }) ||
      (File.basename($0) == 'thor') &&
      (%w{reset}.any? { |task| ARGV.include?("dradis:#{task}") })
    )
      # Running rake, disable import/export plugins. See r874
      # http://dradis.svn.sourceforge.net/viewvc/dradis/server/trunk/config/environment.rb?view=log#rev874
      #
      # At least include the project_management plugin that will allow us to
      # create a project package (for backup) and is known not to interact with
      # the DB
      config.plugins = [:acts_as_tree, :project_management ]
    else
      config.active_record.observers = :revision_observer
    end     

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w()

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]
  end
end

require 'core/configurator'
