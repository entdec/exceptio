require "exceptio/engine"

module Exceptio
  class Error < StandardError; end

  class Configuration
    attr_accessor :base_controller
    attr_writer   :logger, :related_sgids, :sgid_to_link, :environment_details

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
      @base_controller = '::ApplicationController'
      @environment_details = -> { {} }
      @related_sgids = -> { [] }
      @sgid_to_path_and_name = -> { nil }
    end

    # Config: logger [Object].
    def logger
      @logger.is_a?(Proc) ? instance_exec(&@logger) : @logger
    end

    # Proc returning array of sgids of relevant objects, like  current user or account
    def related_sgids
      instance_exec(&@related_sgids) if @related_sgids.is_a?(Proc)
    end

    # Proc returning [path, name] for the specified sgid (path to and name of user or account)
    def sgid_to_path_and_name(sgid)
      instance_exec(&@sgid_to_link, sgid) if @sgid_to_link.is_a?(Proc)
    end

    # Proc returning extra environment details (hash) to be stored with the exception
    def environment_details
      instance_exec(&@environment_details) if @environment_details.is_a?(Proc)
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
