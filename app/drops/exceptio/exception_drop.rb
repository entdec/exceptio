module Exceptio
  class ExceptionDrop < ApplicationDrop
    delegate :id, :exception_class, :code_location, :instances, to: :@object
  end
end