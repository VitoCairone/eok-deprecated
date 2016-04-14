class User < ActiveRecord::Base
	has_many :user_auths
	# note: a User will *usually* have just one UserAuth
	# but formally speaking the relationship is has_many

	before_create :set_last_allowance_to_now

	def set_last_allowance_to_now
		self.last_allowance = Time.now unless self.last_allowance.present?
	end
end
