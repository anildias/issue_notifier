#
# Model DeviceToken handles token and device platform info
# Maintains belongs_to association with User class
#

class DeviceToken < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :token, :scope => :user_id
end
