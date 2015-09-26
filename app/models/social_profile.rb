class SocialProfile < ActiveRecord::Base
  belongs_to :user

  validates :user, :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.from_omniauth(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end

  def provider_name
    if provider == "google_oauth2"
      "Google"
    else
      provider.titleize
    end
  end
end
