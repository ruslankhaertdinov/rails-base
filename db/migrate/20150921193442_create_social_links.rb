class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
    end

    add_index :social_links, :provider
    add_index :social_links, :uid
  end
end
