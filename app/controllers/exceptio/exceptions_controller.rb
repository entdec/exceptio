# frozen_string_literal: true

# require_dependency 'exceptio/application_controller'

module Exceptio
  class ExceptionsController < ::Exceptio::ApplicationController
    def index
      redirect_to main_app.root_path unless Current.user && (Current.user.is_admin? || Current.user.is_billing_admin?)
      @exceptions = ::Exceptio::Exception.all.order(updated_at: :desc)
    end

    def show
      @exception = ::Exceptio::Exception.find(params[:id])
    end

    def destroy
      @exception = ::Exceptio::Exception.find(params[:id])
      @exception.destroy
      redirect_to action: :index, status: :see_other
    end

    def delete_all
      ::Exceptio::Exception.destroy_all
      redirect_to action: :index, status: :see_other
    end
  end
end
