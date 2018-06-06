Exceptio.logger.info("Loading Rails (#{Rails.version}) integration")

require "exceptio/rack/rails_instrumentation"

module Exceptio
  # @api private
  class Railtie < ::Rails::Railtie
    initializer "exceptio.configure_rails_initialization" do |app|
      Exceptio::Railtie.initialize_exceptio(app)
    end

    def self.initialize_exceptio(app)
      # Load config
      # Exceptio.config = Exceptio::Config.new(
      #     Rails.root,
      #     Rails.env,
      #     :name => Rails.application.class.parent_name,
      #     :log_path => Rails.root.join("log")
      # )

      # Start logger
      # Appsignal.start_logger

      app.middleware.insert_after(
          ActionDispatch::DebugExceptions,
          Exceptio::Rack::RailsInstrumentation
      )

      # if Appsignal.config[:enable_frontend_error_catching]
      #   app.middleware.insert_before(
      #       Appsignal::Rack::RailsInstrumentation,
      #       Appsignal::Rack::JSExceptionCatcher
      #   )
      # end

      # Appsignal.start
    end
  end
end
