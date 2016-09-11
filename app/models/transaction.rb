class Transaction < ActiveRecord::Base
	def self.charge_user(amount, user) # current_user is the user
		puts "Current user is #{user}"
		puts "LETS CHARGE THEM $ #{amount}"
		puts "THE CURRENT USER IS #{user.braintree_id}"
		#payment method is stored in the vault
		result = Braintree::Transaction.sale(
		  :customer_id => user.braintree_id,
		  :amount => amount
		)
		if result.success?
			puts "WE JUST CHARGED THEM LOTS OF MONEY"
		else
			p result.errors
		end

	end
end
