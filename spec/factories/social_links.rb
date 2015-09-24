FactoryGirl.define do
  factory :social_link do
    user
    uid "12345"
  end

  trait :facebook do
    provider "facebook"
  end

  trait :google do
    provider "google_oauth2"
  end
end
