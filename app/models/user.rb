class User < ActiveRecord::Base
	before_create :set_last_allowance_to_now

	def set_last_allowance_to_now
		self.last_allowance = Time.now unless self.last_allowance.present?
	end

end
