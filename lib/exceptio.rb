require "exceptio/engine"

module Exceptio
  class Error < StandardError; end

  # Config: logger [Object].
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO
  mattr_writer :logger
  def self.logger
    @@logger.is_a?(Proc) ? instance_exec(&@@logger) : @@logger
  end

end

require "exceptio/railtie" if defined?(::Rails)
