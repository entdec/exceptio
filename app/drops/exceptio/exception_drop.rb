module Exceptio
  class ExceptionDrop < ApplicationDrop
    delegate :id, :exception_class, :backtrace, :instances, :instances_count, :last_instance_at , to: :@object

    def code_location
      backtrace.first
    end
  end
end