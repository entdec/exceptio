# frozen_string_literal: true

class ExceptioExceptionsTable < ActionTable::ActionTable
  model Exceptio::Exception

  column(:exception_class)
  column(:message) { |exception| exception.message.to_s.truncate(40) }
  column(:code_location) { |exception| exception.code_location.to_s.gsub(Rails.root.to_s, '').truncate(20) }
  column(:count)
  column(:last_occurence, sort_field: :updated_at) { |exception| ln exception.updated_at }
  column(:actions) do |exception|
    link_to '<i class="fal fa-trash"></i>'.html_safe, exceptio.exception_path(exception),
            data: { turbo_method: :delete }
  end

  initial_order :last_occurence, :desc

  row_link { |exception| exceptio.exception_path(exception) }

  filter(:query) { |value| where('id::text ILIKE :query', query: "#{value}%") }

  private

  def scope
    @scope ||= Exceptio::Exception.left_joins(:instances).all.select('exceptio_exceptions.*, count(exceptio_instances.id) as count').group('exceptio_exceptions.id')
  end
end
