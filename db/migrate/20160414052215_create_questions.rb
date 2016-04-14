class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :uid, null: false
      t.string :text, null: false
      t.references :user, index: true, foreign_key: true
      t.string :author_name
      t.integer :points, default: 0
      t.integer :passes, default: 0
      t.boolean :free_choice, default: false
      t.boolean :randomized, default: false
      t.boolean :opinion, default: false

      t.timestamps null: false
    end

    # find/join indexes
    add_index :questions, :uid

    # sorting indexes
    add_index :questions, :points
  end
end
