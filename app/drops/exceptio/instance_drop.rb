module Exceptio
  class InstanceDrop < ApplicationDrop
    delegate :id, :exception_id, :message, :context, :exceptio_exceptionable_id, :exceptio_exceptionable_type, to: :@object
  end
end