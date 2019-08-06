# frozen_string_literal: true

module Exceptio
  class Exception < ApplicationRecord
    has_many :instances, dependent: :destroy

    delegate :message, to: :last_instance

    def last_instance
      instances.order(created_at: :desc).first
    end

    class << self
      def for(exception)
        where(exception_class: exception.class.name, code_location: exception.backtrace.first).first_or_initialize
      end
    end
  end
end
