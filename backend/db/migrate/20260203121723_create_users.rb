class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name
      t.string :comment
      t.string :password_digest

      t.timestamps
    end
  end
end
