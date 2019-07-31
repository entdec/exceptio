# frozen_string_literal: true

module Exceptio
  class ExceptionsController < ApplicationController
    add_breadcrumb I18n.t('exceptio.breadcrumbs.exceptions'), :exceptions_path if defined? add_breadcrumb

    def index
      @exceptions = ::Exceptio::Exception.all
    end

    def show
      @exception = ::Exceptio::Exception.find(params[:id])
      add_breadcrumb(@exception.exception_class, exception_path(@exception)) if defined? add_breadcrumb
    end
  end
end
