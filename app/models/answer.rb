class Answer < ActiveRecord::Base
  belongs_to :question
  has_one :user, through: :question

  def response_count
    Choice.where(answer_id: self.id, ordinality: 1).count
  end
end
