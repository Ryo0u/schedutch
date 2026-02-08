class RefactorResponsesStructure < ActiveRecord::Migration[8.1]
  def change
    drop_table :responses, if_exists: true
    drop_table :time_slots, if_exists: true

    # 3. 新しい responses テーブル
    create_table :responses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :candidate, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.integer :status, default: 0, null: false 

      t.timestamps
    end

    add_index :responses, [:user_id, :candidate_id, :start_time], unique: true, name: 'unique_user_response'
  end
end