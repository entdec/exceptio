class AddIndices1 < ActiveRecord::Migration[5.2]
  def change
    add_index :exceptio_exceptions, :created_at
    add_index :exceptio_exceptions, :updated_at
    add_index :exceptio_exceptions, :last_instance_at
    add_index :exceptio_instances, :exception_id
  end
end
