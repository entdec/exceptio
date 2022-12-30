class AddOwnableToInstance < ActiveRecord::Migration[7.0]
  def change
    add_column :exceptio_instances, :exceptio_exceptionable_id, :uuid
    add_column :exceptio_instances, :exceptio_exceptionable_type, :string
  end
end
