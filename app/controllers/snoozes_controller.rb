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

  	# MO'S ACC
	# account_sid = 'ACf300bfeed24ce57a555d6595534b3381'
	# auth_token = 'b28595ac7328abc19c2fdc70f9df70eb'

  	# JADE ACC
	account_sid = 'AC10f0217b511b0dc610e7c084e5aaf92f'
	auth_token = '12a4d1bb986ac4657d7598fa8a61d8e6'

	@client = Twilio::REST::Client.new(account_sid, auth_token)
	puts "CLIENT IS #{@client}"

	threshold = 1

	def timer(val = threshold)
	  start_time = Time.now.to_i
	  activate = start_time + val
	  [activate, start_time]
	end

	activate, start_time = timer(1)

	if threshold >= (activate - start_time)
	  @client.account.messages.create(
	  	body: 'Your friend Jade has been snoozing for 30 minutes. Type CALL to wake her up through an automated call.',
	    to: '+16282208811',
	    from: '+15005550006')
	    # from: '+14154291817')
	  puts "JUST SENT THEM TEXT MESSAGE"
	end
  end


	def sms
	    inbound_sms = params['Body']
	    puts "THEY REPLIED SAYING #{inbound_sms}"

	    if inbound_sms.to_s == 'CALL'
	      puts "HELLO THIS IS FUCKED UP SHIT"
	      call = @client.account.calls.create(
		      from: '+15005550006',
		      # from: '+14154291817',
		      to: '+16282208811',
		      url: 'https://handler.twilio.com/twiml/EHff1643465456dc29f1e82bb6a05557bd'
		  	)
	    puts "GONNA CALL NOW!!!"
	      Twilio::TwiML::Response.new(call)

	    else
	      twiml = Twilio::TwiML::Response.new do |r|
	        r.Message do |message|
	          message.Body '"Sorry, that did not work."'

	        end
	      end
	    end
	    return twiml.text
	end

	# make_call




  def third
  	# final thing

  end
end
