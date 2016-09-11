class SnoozesController < ApplicationController
  def first
  	# charge money
  	puts "GONNA CHARGE THEM MONEY! FIRST SNOOZE"
  	result = Transaction.charge_user(2.50, current_user)
  	result
  end

  def second
  	# charge them more money
  	puts "GONNA CHARGE THEM MONEY! FIRST SNOOZE"
  	Transaction.charge_user(5.00, current_user)
  	# send twilio
  	
  end

  def third
  	# final thing
  end
end
