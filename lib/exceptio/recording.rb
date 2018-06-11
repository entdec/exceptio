require "exceptio/rack/rails_instrumentation"

module Exceptio
  # @api private
  class Recording

    attr_reader :recording_id

    class << self
      def create(recording_id, namespace, request, options = {})
        # Allow middleware to force a new recording
        if options.include?(:force) && options[:force]
          Thread.current[:exceptio_recording] = nil
        end

        # Check if we already have a running recording
        if Thread.current[:exceptio_recording] != nil
          # Log the issue and return the current recording
          Exceptio.logger.debug "Trying to start new recording with id " \
            "'#{recording_id}', but a recording with id '#{current.recording_id}' " \
            "is already running. Using recording '#{current.recording_id}'."

          # Return the current (running) recording
          current
        else
          # Otherwise, start a new exceptio_recording
          Thread.current[:exceptio_recording] = Exceptio::Recording.new(recording_id, namespace, request, options)
        end
      end

      def current
        Thread.current[:exceptio_recording]
      end

      def store!
        current.store
      rescue => e
        Exceptio.logger.error("Failed to complete recording ##{current.recording_id}. #{e.message}")
      ensure
        clear_current_transaction!
      end

      # Remove current recording from current Thread.
      # @api private
      def clear_current_recording!
        Thread.current[:exceptio_recording] = nil
      end
    end

    def initialize(recording_id, namespace, request, options = {})
      @recording_id = recording_id
      @action = nil
      @namespace = namespace
      @request = request
      @tags = {}
      @options = options
      @options[:params_method] ||= :params
      @error = nil
      @metadata = {}
    end

    def set_error(error)
      return unless error

      backtrace = cleaned_backtrace(error.backtrace)
      @error = {class_name: error.class.name, message: error.message.to_s, backtrace: backtrace || []}
    end

    def set_metadata(key, value = '')
      @metadata[key] = value
    end

    def cleaned_backtrace(backtrace)
      if defined?(::Rails) && backtrace
        ::Rails.backtrace_cleaner.clean(backtrace, nil)
      else
        backtrace
      end
    end

    def environment
      return {} unless request.respond_to?(:env)
      return {} unless request.env

      request.env
    end

    def store
      Exceptio.logger.debug "recording: #{self.inspect}"
    end
  end
end
