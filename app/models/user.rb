class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: Identity::PROVIDERS

  has_many :identities, dependent: :destroy

  validates :full_name, presence: true
end
