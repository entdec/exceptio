# frozen_string_literal: true

class Exceptio::ExceptionsTable < Mensa::Base
  definition do
    model Exceptio::Exception

    column(:exception_class)
    column(:message) do
      render do
        html do |exception|
          exception.message.to_s.truncate(40)
        end
      end
    end
    column(:code_location) do
      render do
        html do |exception|
          exception.code_location.to_s.gsub(Rails.root.to_s, '').truncate(20)
        end
      end
    end
    column(:count) do
      render do
        html do |exception|
          exception.instances.size
        end
      end
    end
    column(:last_instance_at) do
      render do
        html do |exception|
          ln exception.last_instance_at
        end
      end
    end
    # column(:actions) { |exception| link_to '<i class="fal fa-trash"></i>'.html_safe, exceptio.exception_path(exception), data: { turbo_method: :delete }}

    # column(:) do
    #   render do
    #     html do |screening|
    #       screening.profiles.join(",")
    #     end
    #   end
    # end

    order last_instance_at: "desc"

    link { |exception| exceptio.exception_path(exception) }

    # filter(:query) { |value| where('id::text ILIKE :query', query: "#{value}%") }
  end

  private

  def scope
    @scope ||= Exceptio::Exception.all
  end
end
