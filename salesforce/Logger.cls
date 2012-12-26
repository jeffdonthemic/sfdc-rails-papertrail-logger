public with sharing class Logger {

	public static void log(String level, String msg, String klass) {
		Log__c l = new Log__c(
			Level__c = level,
			Short_Message__c = msg.substring(0,msg.length() > 255 ? 255 : msg.length()),
			Extended_Message__c = msg,
			Class__c = klass
		);

		try {
			insert l; 
		} catch (Exception e) {
			// how do you want to log log exceptions!!
			System.debug('Logger exception: ' + e.getMessage());
		}
		
	}

	static testMethod void testLogger() {

		String msg = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut sollicitudin ligula. Mauris a est erat, et ultrices ipsum. Aliquam id massa neque, non placerat quam. Morbi ultricies tristique lobortis. Sed ac ante et quam cursus aliquam id laoreet dui. Donec quis tortor turpis, ut luctus mi. Nulla a condimentum sem. Praesent tortor velit, egestas in euismod scelerisque, consequat et dui. Ut eu magna sapien. In hac habitasse platea dictumst. Fusce turpis felis, dapibus eget gravida at, rutrum sed ligula. Nullam tincidunt ultricies tellus, tempor ullamcorper quam viverra id. Nam auctor, turpis eget pellentesque scelerisque, dolor tellus faucibus eros, bibendum tempus justo urna fringilla est.';

		Logger.log('INFO',msg,'MyTestClass.cls');

		Log__c log = [select level__c, short_message__c, extended_message__c, class__c from log__c where class__c = 'MyTestClass.cls'];

		System.assertEquals(log.level__c,'INFO');
		System.assertEquals(log.Short_Message__c,msg.substring(0,255));
		System.assertEquals(log.Extended_Message__c,msg);
		System.assertEquals(log.Class__c,'MyTestClass.cls');

	}

	static testMethod void testLoggerException() {

		Logger.log(null,'Some Text','MyExcetionClass.cls');
		System.assertEquals(0,[select count() from log__c where class__c = 'MyExcetionClass.cls']);

	}

}
