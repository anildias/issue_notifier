#
# Module UserPatch is for to extend the relation for User to have has_many association to DeviceToken
#

module UserPatch
  def self.included(base)
    base.class_eval do
      has_many :device_tokens
    end
  end
end