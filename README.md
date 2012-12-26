# sfdc-rails-papertrail-logger

Ruby on Rails application using [Restforce](https://github.com/ejholmes/restforce) that catches streamed records from salesforce and logs them via [Papertrail](http://www.papertrailapp.com).

### Installing the Logger assets in Salesforce.com

Install the Log__c custom object and Logger.cls class from the saleforce directory into your org. Use the Logger Apex class to add Log records.

### Setup Remote Access in Salesforce.com

Setup a new Remote Access to get your OAuth tokens. If you are unfamiliar with settng this up, see 4:45 of my [Salesforce.com Primer for New Developers](http://www.youtube.com/watch?v=fq2ju2ML9GM). For your callback, simply use: http://localhost:3000

### Create a PushTopic in Salesforce.com

Create a new PushTopic from the Developer Console in your org with the following. This will setup the endpoint for faye to listen to:

	PushTopic pt = new PushTopic();  
	pt.apiversion = 26.0;  
	pt.name = 'LogEntries';
	pt.description = 'All new logger records';  
	pt.query = 'select id, name, level__c, short_message__c, class__c from log__c'; 
	pt.notifyforoperations = 'create';
	pt.notifyforfields = 'All'; 
	insert pt;  
	System.debug('Created new PushTopic: '+ pt.Id);

You can also set up PushTopics using the [Workbench](https://workbench.developerforce.com).

### Running the Application Locally

From the command line type in:

	git clone https://github.com/jeffdonthemic/sfdc-rails-papertrail-logger.git
	cd sfdc-rails-papertrail-logger
	bundle install

This will clone this repo locally so you simply have to make your config changes and be up and running. You should have the [Heroku Toolbelt](https://toolbelt.heroku.com) installed so that you can start the app using Foreman with the same environment as Heroku. Create an '.env' file in your root directory and add your OAuth configuration for the application. Don't forget to add this file to '.gitignore' so that your variables are exposed.

	SFDC_USERNAME=[YOUR-SFDC-USERNAME]
	SFDC_PASSWORD=[YOUR-SFDC-PASSWORD]
	SFDC_SECURITY_TOKEN=[YOUR-USER-SECURITY-TOKEN]
	SFDC_CLIENT_ID=[REMOTE-ACCESS-CONSUMER-KEY]
	SFDC_CLIENT_SECRET=[REMOTE-ACCESS-CONSUMER-SECRET]

Start the application by running 'foreman start -p 3000' and then point your browser to [http://localhost:3000](http://localhost:3000). Log into Salesforce and manually add a new Log__c record and watch the magic as log records appear in the terminal!

### Deploy to Heroku

	heroku create sfdc-rails-papertrail-logger

	heroku config:add SFDC_USERNAME=[YOUR-SFDC-USERNAME]
	heroku config:add SFDC_PASSWORD=[YOUR-SFDC-PASSWORD]
	heroku config:add SFDC_SECURITY_TOKEN=[YOUR-USER-SECURITY-TOKEN]
	heroku config:add SFDC_CLIENT_ID=[REMOTE-ACCESS-CONSUMER-KEY]
	heroku config:add SFDC_CLIENT_SECRET=[REMOTE-ACCESS-CONSUMER-SECRET]

	git push heroku master

Add the Papertrail add-on from the app in Heroku or with:

	heroku addons:add papertrail:choklad

Open Papertrail by clicking on "Papertrail Choklad" from the Heroku Resources page for the application.

Now adding records to the Log__c custom object will show up in Papertrail!

One thing to remember is that Heroku will shut down your app after an hour of inactivity if you only have one dyno configured. So, to keep this app running and listening for event records, you will have to scale it to 2 dynos.

