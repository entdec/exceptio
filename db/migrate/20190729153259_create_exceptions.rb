class CreateExceptions < ActiveRecord::Migration[5.2]
  def change
    create_table :exceptions, id: :uuid do |t|
      t.string :exception_class
      t.string :code_location

      t.timestamps null: false
    end

    create_table :exception_instances do |t|
      t.uuid :exception_id
      t.string :related_sgids, array: true, default: []
      t.string :log_lines, array: true, default: []
      t.jsonb :environment
      t.jsonb :detailed_backtrace

      t.timestamps null: false
    end
  end
end
