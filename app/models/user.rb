class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:google_oauth2]

  validates :full_name, presence: true

  has_many :social_links

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.full_name = auth.info.name
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
      user.save!
    end
  end

  def to_s
    full_name
  end

  def full_name_with_email
    "#{self[:full_name]} (#{email})"
  end

  def apply_omniauth(auth)
    self.email = auth.info.email
    self.full_name = auth.info.name
    self.password = Devise.friendly_token[0,20]
    social_links.build(provider: auth.provider, uid: auth.uid)
  end
end
