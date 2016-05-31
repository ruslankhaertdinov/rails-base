FactoryGirl.define do
  factory :identity do
    user
    provider "facebook"
    uid "123545"
  end
end
