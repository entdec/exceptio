# frozen_string_literal: true

module Exceptio
  class Instance < ApplicationRecord
    belongs_to :exception, counter_cache: true, touch: :last_instance_at
    belongs_to :exceptio_exceptionable, polymorphic: true, optional: true

    def related_objects
      related_data.map(&:first).compact
    end

    def related_data
      related_sgids.map { |sgid| Exceptio.config.sgid_to_object_url_name(sgid) }.compact
    end

    def browser
      return nil unless request_env

      Browser.new(request_env['HTTP_USER_AGENT'], accept_language: request_env['HTTP_ACCEPT_LANGUAGE'])
    end

    def request_env
      return {} unless context.key?('request_env')

      JSON.parse(context['request_env'])
    end

    def job
      return {} unless context.key?('job')

      JSON.parse(context['job'])
    end

    def job?
      context.key?('job')
    end

    def web?
      context.key?('request_env')
    end
  end
end
