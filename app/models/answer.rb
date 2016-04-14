class Answer < ActiveRecord::Base
  belongs_to :question
  has_one :user, through: :question
end
