# frozen_string_literal: true

module Exceptio
  class ApplicationService
    def call
      perform
    end

    private

    def log(level, message)
      message = "#{self.class.name}: #{message}"
      Exceptio.logger.public_send level, message
      Praesens.log_lines ||= []
      Praesens.log_lines << message
    end

    def log_exception(exception)
      log :error, exception.message
      log :error, exception.backtrace.join(';')
      Praesens.log_lines.each { |line| Exceptio.logger.error(line) }
    end

    def pull_log_lines
      @log_lines = Praesens.log_lines
      Praesens.log_lines = []
      @log_lines
    end

    class << self
      def call
        new.call
      end
    end
  end
end
