# frozen_string_literal: true

module Exceptio
  class Exception < ApplicationRecord
    has_many :exception_instances, dependent: :destroy

    class << self
      def for(exception)
        where(exception_class: exception.class.name, code_location: exception.backtrace.first).first_or_initialize
      end
    end
  end
end
