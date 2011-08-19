package com.deCampredon.flexAcacia.validation.test.subscribers
{
	import com.deCampredon.flexAcacia.validation.subscribers.ValidationSubscriber;

	public class ValidationSubscriberTest
	{
		public var validationSubscribers:ValidationSubscriber;
		public var mockValidationListener:MockValidatorListener;
		
		[Before]
		public function setUp():void
		{
			validationSubscribers = new ValidationSubscriber();
			mockValidationListener = new MockValidatorListener();
			validationSubscribers.source = mockValidationListener;
		}
	}
}