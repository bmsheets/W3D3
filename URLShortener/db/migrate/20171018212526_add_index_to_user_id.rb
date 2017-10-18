class AddIndexToUserId < ActiveRecord::Migration[5.1]
  def change
    add_index :shortened_urls, :user_id
  end
end
