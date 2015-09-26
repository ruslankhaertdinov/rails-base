class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links do |t|
      t.references :user, index: true
      t.string :provider, index: true
      t.string :uid, index: true
    end
  end
end
