module Exceptio
  class ApplicationController < Exceptio.config.base_controller.constantize
    protect_from_forgery with: :exception

    layout Nuntius.config.admin_layout
  end
end
