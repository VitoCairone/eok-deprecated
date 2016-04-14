class CreateUserAuths < ActiveRecord::Migration
  def change
    create_table :user_auths do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :name
      t.string :location
      t.string :image_url
      t.string :url
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    # find/join indexes
    add_index :user_auths, :provider
    add_index :user_auths, :uid
    add_index :user_auths, [:provider, :uid], unique: true
  end
end
