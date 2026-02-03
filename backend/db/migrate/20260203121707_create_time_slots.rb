class CreateTimeSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :time_slots do |t|
      t.references :candidate, null: false, foreign_key: true
      t.datetime :start_time

      t.timestamps
    end
  end
end
