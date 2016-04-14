class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.references :answer, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :ordinality, default: 1
      t.references :question, index: true, foreign_key: true
      t.boolean :pass, default: false

      t.timestamps null: false
    end

    # find/join indexes
    # find a given user's own choice(s) for a particular question
    add_index :choices, [:user_id, :question_id, :ordinality], unique: true
  end
end