class QuestionsController < ApplicationController
	before_action :set_question, only: [:show, :edit, :update, :destroy]

	def index
		# @questions = Question.next_unseen_set_for(current_user)
		@questions = Question.all # dev-ing, K.I.S.S.
	end

  def show
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
    # not implemented / untested
  end

  def create
    q_params = question_params

    # the request isn't allowed to tell us a user_id.
    # We set it to the current_user's id by our own reckoning.
    q_params['user_id'] = current_user.id

    # placeholder for human-readable UID system to be implemented later
    q_params['uid'] = SecureRandom.urlsafe_base64(10)

    answers_attributes = q_params['answers_attributes']

    # drop all blank answers
    answers_attributes.keep_if { |k, v| !v['text'].blank? }

    # assign serial numbers. We don't use the param number because users
    # might skip slots in the form. This way, even if slots are skipped,
    # an unbroken sequence of numbers starting with 1 is still assigned.
    answers_attributes.each_with_index do |(k, v), idx|
      v['number'] = idx + 1
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
    # untested
    q_params = question_params
    q_params['speaker_id'] = current_speaker.id
    if @question.update(q_params)
      flash[:success] = 'Question was successfully updated.'
      redirect_to @question
    else
    	flash[:warning] = 'Sorry, an error prevented saving your changes.'
      render :edit
    end
  end

  def destroy
    # untested
    @question.destroy
    flash[:success] = "Question has been deleted."
		redirect_to root_path
  end

  def respond
    # TODO: ensure_logged_in first

    # set some shorthand vars
    question_id = params[:question_id]
    choice_num = params[:number]
    user_id = current_user.id

    # Find the answer that was chosen
    @answer = Answer.find_by(question_id: question_id, number: choice_num)
    answer_id = @answer.id

    # Clear this user's existing choices for this question, if any.
    # delete_all is faster, but destroy_all is safer in case we ever add callbacks.
    # In most cases there will be no matching records so speed isn't a huge concern.
    Choice.destroy_all(question_id: question_id, user_id: user_id)

    # Create the new choice record for the chosen answer
    @choice = Choice.new(question_id: question_id, user_id: user_id, answer_id: answer_id)
    @choice_was_saved = @choice.save

    # set @question so respond.js can re-render the right partial
    @question = Question.find(question_id)

    respond_to do |format|
      format.js
    end
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
