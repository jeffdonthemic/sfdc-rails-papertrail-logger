require 'restforce'
require 'faye'

# Initialize a client with your username/password.
client = Restforce.new :username => ENV['SFDC_USERNAME'],
  :password       => ENV['SFDC_PASSWORD'],
  :security_token => ENV['SFDC_SECURITY_TOKEN'],
  :client_id      => ENV['SFDC_CLIENT_ID'],
  :client_secret  => ENV['SFDC_CLIENT_SECRET']

# simply for debugging
puts client.to_yaml

begin

	client.authenticate!
	puts 'Successfully authenticated to salesforce.com'

	EM.next_tick do
	  client.subscribe 'LogEntries' do |message|
			puts "[#{message['sobject']['Level__c']}] #{message['sobject']['Class__c']} - #{message['sobject']['Short_Message__c']} (#{message['sobject']['Name']})"
	  end
	end

rescue
  puts "Could not authenticate. Not listening for streaming events."
end