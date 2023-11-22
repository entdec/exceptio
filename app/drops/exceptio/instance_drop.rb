module Exceptio
  class InstanceDrop < ApplicationDrop
    delegate :id, :exception, :exception_id, :message, :context, :exceptio_exceptionable, :exceptio_exceptionable_id, :exceptio_exceptionable_type, :log_lines, to: :@object
  end
end