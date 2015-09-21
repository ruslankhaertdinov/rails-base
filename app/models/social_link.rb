class SocialLink < ActiveRecord::Base
  belongs_to :user

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid)
  end
end
