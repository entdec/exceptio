module Exceptio
  class ExceptionDrop < ApplicationDrop
    delegate :id, :exception_class, :code_location, :instances, :instances_count, :last_instance_at , to: :@object
  end
end