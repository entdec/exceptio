# frozen_string_literal: true

module Exceptio
  class Instance < ApplicationRecord
    belongs_to :exception, counter_cache: true, touch: :last_instance_at

    def related_objects
      related_data.map(&:first).compact
    end

    def related_data
      related_sgids.map { |sgid| Exceptio.config.sgid_to_object_url_name(sgid) }.compact
    end
  end
end
