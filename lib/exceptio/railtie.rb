Exceptio.logger.info("Loading Rails (#{Rails.version}) integration")

require "exceptio/rack/rails_instrumentation"

module Exceptio
  # @api private
  class Railtie < ::Rails::Railtie
    initializer "exceptio.configure_rails_initialization" do |app|
      Exceptio::Railtie.initialize_exceptio(app)
    end

    def self.initialize_exceptio(app)
      app.middleware.insert_after(
          ActionDispatch::DebugExceptions,
          Exceptio::Rack::RailsInstrumentation
      )
    end
  end
end
