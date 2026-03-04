class AddIndexToEventsUrlToken < ActiveRecord::Migration[8.1]
  def change
    add_index :events, :url_token, unique: true
  end
end
