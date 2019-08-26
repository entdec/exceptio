# frozen_string_literal: true

module Exceptio
  class ExceptionRecordingService < ApplicationService
    attr_reader :exception, :context

    def initialize(exception, context = {})
      @exception = exception
      @context = context
    end

    def perform
      model = ::Exceptio::Exception.for(exception)
      log :error, "processing exception: #{exception.message}"
      return if model.instances.size >= Exceptio.config.max_occurences

      # Always update the backtrace, versions, code locations might change, want to deal with the latest only.
      model.detailed_backtrace = BacktraceEnrichmentService.new(exception.backtrace).call

      instance = model.instances.build(
        message: exception.message,
        related_sgids: Exceptio.config.related_sgids || [],
        context: Exceptio.config.context_details.merge(context)
      )

      model.save!

      Exceptio.config.after_exception(model, instance)

      nil
    rescue StandardError => outer_exception
      Rails.logger.error '=' * 80
      Rails.logger.error "EXCEPTION SAVING EXCEPTION: #{outer_exception.message} DURING CAPTURE OF #{exception&.message}"
      Rails.logger.error "Outer: #{outer_exception.message}\n#{outer_exception.backtrace.join("\n")}"
      Rails.logger.error '-' * 80
      Rails.logger.error "Inner: #{exception&.message}\n#{exception&.backtrace&.join("\n")}"
      Rails.logger.error '=' * 80
    end
  end
end
