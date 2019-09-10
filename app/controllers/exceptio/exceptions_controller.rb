# frozen_string_literal: true

# require_dependency 'exceptio/application_controller'

module Exceptio
  class ExceptionsController < ::Exceptio::ApplicationController
    add_breadcrumb I18n.t('exceptio.breadcrumbs.exceptions'), :exceptions_path if defined? add_breadcrumb

    def index
      @exceptions = ::Exceptio::Exception.all
    end

    def show
      @exception = ::Exceptio::Exception.find(params[:id])
      add_breadcrumb(@exception.exception_class, exception_path(@exception)) if defined? add_breadcrumb
    end

    def destroy
      @exception = ::Exceptio::Exception.find(params[:id])
      @exception.destroy
      redirect_to action: :index
    end
  end
end
