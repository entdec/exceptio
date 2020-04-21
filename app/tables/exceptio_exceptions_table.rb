# frozen_string_literal: true

class ExceptioExceptionsTable < ActionTable::ActionTable
  model Exceptio::Exception

  column(:exception_class)
  column(:message) { |exception| exception.message.to_s.truncate(40) }
  column(:code_location) { |exception| exception.code_location.to_s.gsub(Rails.root.to_s, '').truncate(20) }
  column(:count) { |exception| exception.instances.size }
  column(:last_occurence, sort_field: :updated_at) { |exception| ln exception.updated_at }
  column(:actions) { |exception| link_to '<i class="fas fa-trash"></i>'.html_safe, exceptio.exception_path(exception), method: :delete }

  initial_order :updated_at, :desc

  row_link { |exception| exceptio.exception_path(exception) }

  private

  def scope
    @scope = Exceptio::Exception.all
  end

  def filtered_scope
    @filtered_scope = scope

    @filtered_scope
  end
end
