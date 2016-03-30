class AddPlatformToDeviceTokens < ActiveRecord::Migration
  def change
    add_column :device_tokens, :platform, :string
  end
end