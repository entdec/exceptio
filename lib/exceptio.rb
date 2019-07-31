require "exceptio/engine"

module Exceptio
  class Error < StandardError; end

  class Configuration
    attr_accessor :base_controller, :max_occurences
    attr_writer   :logger, :related_sgids, :sgid_to_object_url_name, :context_details, :after_exception

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
      @base_controller = '::ApplicationController'
      @context_details = -> { {} }
      @related_sgids = -> { [] }
      @sgid_to_object_url_name = -> { nil }
      @after_exception = -> {}
      @max_occurences = 100
    end

    # Config: logger [Object].
    def logger
      @logger.is_a?(Proc) ? instance_exec(&@logger) : @logger
    end

    # Proc returning array of sgids of relevant objects, like  current user or account
    def related_sgids
      instance_exec(&@related_sgids) if @related_sgids.is_a?(Proc)
    end

    # Proc returning [object, path, name] for the specified sgid (path to and name of user or account)
    def sgid_to_object_url_name(sgid)
      instance_exec(sgid, &@sgid_to_object_url_name) if @sgid_to_object_url_name.is_a?(Proc)
    end

    # Proc returning extra environment details (hash) to be stored with the exception
    def context_details
      context = instance_exec(&@context_details) if @context_details.is_a?(Proc)
      context || {}
    end

    def after_exception(exception, instance)
      instance_exec(exception, instance, &@after_exception) if @after_exception.is_a?(Proc)
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
