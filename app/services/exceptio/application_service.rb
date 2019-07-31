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
    end

    class << self
      def call
        new.call
      end
    end
  end
end
