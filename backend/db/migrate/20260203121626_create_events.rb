class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :url_token
      t.string :password_digest
      t.text :description

      t.timestamps
    end
  end
end
