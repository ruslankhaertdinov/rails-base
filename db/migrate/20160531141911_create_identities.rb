class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true
      t.string :provider, index: true, null: false, default: ""
      t.string :uid, index: true, null: false, default: ""
    end
  end
end
