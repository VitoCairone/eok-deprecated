class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid, null: false
      t.string :name, null: false
      t.string :location
      t.string :image_url
      t.integer :points, default: 200
      t.integer :free_points, default: 200
      t.timestamp :last_allowance
      t.integer :lifetime_spent, default: 0
      t.string :session_token, limit: 64

      t.timestamps null: false
    end

    # find/join indexes
    add_index :users, :uid
    add_index :users, :session_token
  end
end

# note: last_allowance cannot have default set to the time of
# record creation by a migration specification,
# instead relies on before_create in User model