class SnoozesController < ApplicationController
	skip_before_filter  :verify_authenticity_token

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

  	# JADE ACC
	account_sid = 'ACebc58fffd7d948fab770dc1465230e9d'
	auth_token = '15e11a3f3664f4da314c49cf53842185'

	@client = Twilio::REST::Client.new(account_sid, auth_token)
	$client = @client
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
	    from: '+16282222767')
	    # from: '+14154291817')
	  puts "JUST SENT THEM TEXT MESSAGE"
	end
  end


	def sms
	    inbound_sms = params['Body']
	    puts "THEY REPLIED SAYING #{inbound_sms}"

	    if inbound_sms.to_s == 'CALL'
	      puts "The client is #{$client}"
	      call = $client.account.calls.create(
		      from: '+16282222767',
		      # from: '+14154291817',
		      to: '+16282208811',
		      # url: 'https://handler.twilio.com/twiml/EHff1643465456dc29f1e82bb6a05557bd'
		      url: 'https://handler.twilio.com/twiml/EH4df330e45ba345f3828ca59be4875baf'
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
