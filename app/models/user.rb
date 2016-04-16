class User < ActiveRecord::Base
	has_many :user_auths
	# note: a User will *usually* have just one UserAuth
	# but formally speaking the relationship is has_many
	has_many :questions
	has_many :answers, through: :questions
	has_many :choices

	before_create :set_last_allowance_to_now

	def set_last_allowance_to_now
		self.last_allowance = Time.now unless self.last_allowance.present?
	end

	# Placeholder function in case we want to give users a way to specify
	# the exact behavior of logout, or provide different ways of logging out.
	# The current behavior is that logout is always across all clients.
	def single_client_logout?
		false
	end

	class << self
	  def from_user_auth(user_auth, login=true)
	  	user = nil
	  	user_is_new = false
	  	if user_auth.user_id
				user = find(user_auth.user_id)
	  	else
	  		user = User.new(uid: SecureRandom.urlsafe_base64(64))
	  		user_is_new = true
	  	end
	    user.name = user_auth.name
	    user.location = user_auth.location
	    user.image_url = user_auth.image_url
	    user.session_token = SecureRandom.urlsafe_base64(64) if login
	    user.save!
	    if user_is_new
	    	user_auth.user_id = user.id
	    	user_auth.save!
	    end
	    user
	  end
	end

end
