module Exceptio
  class ApplicationController < Exceptio.config.base_controller.constantize
    protect_from_forgery with: :exception
  end
end
