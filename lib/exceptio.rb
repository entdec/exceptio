require "exceptio/engine"

module Exceptio
  class Error < StandardError; end

  class Configuration
    attr_accessor :base_controller
    attr_writer   :logger

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
      @base_controller = '::ApplicationController'
    end

    # Config: logger [Object].
    def logger
      @logger.is_a?(Proc) ? instance_exec(&@logger) : @logger
    end
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def setup
      yield config
    end

    def logger
      config.logger
    end

    def active?
      false
    end
  end
end

require "exceptio/railtie" if defined?(::Rails)
require "exceptio/recording"
