class SocialLink < ActiveRecord::Base
  belongs_to :user

  validates :user, :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first
  end

  def provider_name
    if provider == "google_oauth2"
      "Google"
    else
      provider.titleize
    end
  end
end
