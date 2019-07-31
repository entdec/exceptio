class CreateExceptions < ActiveRecord::Migration[5.2]
  def change
    create_table :exceptio_exceptions, id: :uuid do |t|
      t.string :exception_class, null: false
      t.string :code_location, null: false
      t.jsonb :detailed_backtrace, default: [], null: false
      t.integer :instances_count, default: 0, null: false

      t.timestamp :last_instance_at
      t.timestamps null: false
    end

    create_table :exceptio_instances do |t|
      t.uuid :exception_id, null: false
      t.string :message, null: false
      t.string :related_sgids, array: true, default: [], null: false
      t.string :log_lines, array: true, default: [], null: false
      t.jsonb :context, default: [], null: false

      t.timestamps null: false
    end
  end
end
