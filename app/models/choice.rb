class Choice < ActiveRecord::Base
  belongs_to :answer
  belongs_to :user
  belongs_to :question
end
