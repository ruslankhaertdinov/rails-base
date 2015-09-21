class User < ActiveRecord::Base
  has_many :social_links

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, presence: true

  def to_s
    full_name
  end

  def full_name_with_email
    "#{self[:full_name]} (#{email})"
  end

  def apply_omniauth(omniauth)
    # self.email = omniauth['user_info']['email'] if email.blank?
    social_links.build(provider: omniauth['provider'], uid: omniauth['uid'])
  end

  def password_required?
    (social_links.empty? || !password.blank?) && super
  end
end
