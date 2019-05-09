require "rails/railtie"

module WebConsole
  class Railtie < ::Rails::Railtie
    config.web_console = ActiveSupport::OrderedOptions.new

    initializer "web_console.initialize" do
      require "bindex"
      require "web_console/extensions"

      ActionDispatch::DebugExceptions.register_interceptor(Interceptor)

      abort "web-console was initialized in #{Rails.env} environment"
    end

    initializer "web_console.insert_middleware" do |app|
      app.middleware.insert_before ActionDispatch::DebugExceptions, Middleware
    end

    initializer "i18n.load_path" do
      config.i18n.load_path.concat(
        Dir[File.expand_path("../locales/*.yml", __FILE__)]
      )
    end
  end
end
