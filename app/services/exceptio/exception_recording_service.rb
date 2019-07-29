# frozen_string_literal: true

module Exceptio
  class ExceptionRecordingService < ApplicationService
    attr_reader :exception
    def initialize(exception)
      @exception = exception
    end

    def perform(context = {})
      model = Exception.for(exception)
      model.message ||= exception.message
      model.backtrace ||= exception.backtrace.join("\n")
      model.occurences ||= []

      return if model.occurences.count >= 100

      model.occurences << {
        occurred_at: Time.now,
        message: exception.message,
        context: context
      }
      result = model.save
      alert_chat(model) if model.occurences.count == 1 || model.occurences.count == 10 || model.occurences.count == 100
      result
    end

    def alert_chat(model)
      ChatMessageJob.perform_later(Config.label, "Execution exception: #{model.message} occurence #{model.occurences.count}", channel: '#tech')
    end

  end
end
