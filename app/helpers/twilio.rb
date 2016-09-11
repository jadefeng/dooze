require 'rubygems'
require 'twilio-ruby'
require 'Time'
require 'sinatra'

account_sid = 'ACf300bfeed24ce57a555d6595534b3381'
auth_token = 'b28595ac7328abc19c2fdc70f9df70eb'

$client = Twilio::REST::Client.new account_sid, auth_token

threshold = 1

def timer(val = threshold)
  start_time = Time.now.to_i
  activate = start_time + val
  [activate, start_time]
end

activate, start_time = timer(1)

if threshold >= (activate - start_time)
  $client.account.messages.create(body: 'Your friend Jade has been snoozing for 30 minutes. Type CALL to wake her up through an automated call.',
                                  to: '+16282287530',
                                  from: '+14154291817')
end

post '/sms' do
  inbound_sms = params['Body']

  if inbound_sms.to_s == 'CALL'
    @call = $client.account.calls.create(
    from: '+14154291817',
    to: '+16282287530',
    url: 'https://handler.twilio.com/twiml/EHff1643465456dc29f1e82bb6a05557bd'
)
    Twilio::TwiML::Response.new(@call)

  else
    twiml = Twilio::TwiML::Response.new do |r|
      r.Message do |message|
        message.Body '"Sorry, that did not work."'

      end
    end
  end
  return twiml.text
end
