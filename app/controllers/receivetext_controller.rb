require 'twilio-ruby'
class ReceivetextController < ApplicationController
  layout "custom"



  def index
    client_name = params[:client]
    if client_name.nil?
      client_name = "jenny"
    end
    capability = Twilio::Util::Capability.new TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN
    # Create an application sid at twilio.com/user/account/apps and use it here
    capability.allow_client_outgoing TWILIO_APP_SID
    capability.allow_client_incoming client_name
    token = capability.generate
    render :index, :locals => {:token => token, :client_name => client_name}
  end

  def voice
    number = params[:PhoneNumber]
    response = Twilio::TwiML::Response.new do |r|
      # Should be your Twilio Number or a verified Caller ID
      r.Dial :callerId => TWILIO_USER_NUMBER do |d|
        # Test to see if the PhoneNumber is a number, or a Client ID. In
        # this case, we detect a Client ID by the presence of non-numbers
        # in the PhoneNumber parameter.
        if /^[\d\+\-\(\) ]+$/.match(number)
          d.Number(CGI::escapeHTML number)
        else
          d.Client "jenny"
        end
      end
    end
    puts response.text.yellow.bold
    render xml: response.text
  end
end