class QuestionsController < ApplicationController
	before_action :set_question, only: [:show, :edit, :update, :destroy]

	def index
		# @questions = Question.next_unseen_set_for(current_user)
		@questions = Question.all # dev-ing, K.I.S.S.
	end

	def new
		# create blank question and answers to sit in the new view
		# so that we can use the same form for 'new' and 'edit'
		# without a lot of extra conditional logic.
		# This placeholder will never be saved to the database.
    @question = Question.new
    7.times { @question.answers.build }
  end

  def edit
  end

  def create
    q_params = question_params

    # the request isn't allowed to 'tell' us a user_id.
    # We set it to the current_user's id by our own reckoning.
    q_params['user_id'] = current_user.id

    answers_attributes = q_params['answers_attributes']
    # drop all blank answers
    answers_attributes.keep_if { |k, v| !v['text'].blank? }
    # set each answer's user_id to the current_user's id also
    answers_attributes.each do |k, v|
      answers_attributes[k]['user_id'] = current_user.id
    end

    # there is no question_id to assign to answers at this point
    # because the question hasn't yet been created.
    # accepts_nested_attributes_for will properly link them up for us.
    @question = Question.new(q_params)

    if @question.save
    	flash[:success] = 'Question successfully created.'
    	redirect_to @question
    else
    	flash[:warning] = "Sorry, an error prevented saving your question."
    	render :new
    end
  end

  def update
    respond_to do |format|
      q_params = question_params
      q_params['speaker_id'] = current_speaker.id
      if @question.update(q_params)
        flash[:success] = 'Question was successfully updated.'
        redirect_to @question
      else
      	flash[:warning] = 'Sorry, an error prevented saving your question.'
        render :edit
      end
    end
  end

  def destroy
    @question.destroy
    flash[:success] = "Question has been deleted."
		redirect_to root_path
  end

  private
  
  # load an existing question to show/edit/update/destroy
  def set_question
    @question = Question.includes(:answers).find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the whitelist through.
  def question_params
    params.require(:question).permit(:text, answers_attributes: [:id, :text, :_destroy])
  end
end
