class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :choices

  accepts_nested_attributes_for :answers, allow_destroy: true

  def self.next_unseen_set_for(user, limit=3)
  	return nil unless user and user.id.is_a? Integer

  	# to get questions this user hasn't seen yet,
  	# we left outer join on the choices table for their choices,
  	# then select those rows where the outer join found no matches
  	# -- hence attached a null choices.id

  	# note: prefer injection over interpolation in .joins if Rails supports it
  	# also prefer syntax .where(choices: { id: null }) if Rails supports it

    Question.joins(<<-JOIN_HEREDOC
	    LEFT OUTER JOIN choices
	    ON choices.question_id = questions.id
	    AND choices.user_id = #{user.id}
	    JOIN_HEREDOC
	    )
      .where("choices.id IS NULL")
      .order(points: :desc)
      .limit(limit)
  end

  def self.seen_set_for(user, limit=3, offset=0)
  	return nil unless user and user.id.is_a? Integer
    Question.joins(:choices)
    				.where(choices: { user_id: user.id, ordinality: 1 })
    				.order(points: desc)
						.limit(limit)
						.offset(offset)
  end
end
