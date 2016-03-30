class AddUserIdToDeviceTokens < ActiveRecord::Migration
  def change
    add_column :device_tokens, :user_id, :integer
  end
end