class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :text, null: false
      t.references :question, index: true, foreign_key: true
      t.integer :number
      t.integer :score, default: 0

      t.timestamps null: false
    end

    # additional indexes are not needed because we strictly
    # limit the number of answers per question
  end
end
