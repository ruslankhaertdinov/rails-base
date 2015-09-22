class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  validates :full_name, presence: true

  has_many :social_links, dependent: :destroy

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
    self.skip_confirmation!
    social_links.build(provider: auth.provider, uid: auth.uid)
    save
    self
  end
end
