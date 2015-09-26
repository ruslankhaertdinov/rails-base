class CreateSocialProfiles < ActiveRecord::Migration
  def change
    create_table :social_profiles do |t|
      t.references :user, index: true
      t.string :provider, index: true
      t.string :uid, index: true
    end
  end
end
