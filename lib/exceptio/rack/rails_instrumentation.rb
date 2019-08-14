require "rack"

module Exceptio
  # @api private
  module Rack
    class RailsInstrumentation
      def initialize(app, options = {})
        # Exceptio.logger.debug 'Initializing Exceptio::Rack::RailsInstrumentation'
        @app = app
        @options = options
      end

      def call(env)
        if Exceptio.active?
          call_with_exceptio(env)
        else
          @app.call(env)
        end
      end

      def call_with_exceptio(env)
        request = ActionDispatch::Request.new(env)

        recording = Exceptio::Recording.create(
            request_id(env),
            'http_request',
            request,
            :params_method => :filtered_parameters
        )
        begin
          @app.call(env)
        rescue Exception => error # rubocop:disable Lint/RescueException
          recording.set_error(error)
          controller = env['action_controller.instance']
          if controller
            recording.set_metadata('action', "#{controller.class}##{controller.action_name}")
          end
          recording.set_metadata('path', request.path)
          recording.set_metadata('method', request.request_method)
          Exceptio::Recording.store!
          raise error
        ensure
          Exceptio::Recording.clear_current_recording!
        end
      end

      def request_id(env)
        env['action_dispatch.request_id'] || SecureRandom.uuid
      end
    end
  end
end
