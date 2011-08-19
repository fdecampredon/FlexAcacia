package com.deCampredon.flexAcacia.validation.test.constraint
{
	import com.deCampredon.flexAcacia.validation.constraints.EmailConstraint;
	
	import mx.events.ValidationResultEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class EmailConstraintTest
	{
		public var testItem:ConstraintTestItem;
		public var emailConstraint:EmailConstraint;
		
		[Before]
		public function setUp():void
		{
			testItem = new ConstraintTestItem();
			emailConstraint = new EmailConstraint();
			emailConstraint.field = "stringProperty";
		}
		
		[Test(async)]
		/**
		 * test than the constraint against a valid email
		 */
		public function validationSuccess():void {
			testItem.stringProperty = "email@domain.com";
			emailConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationSuccessComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertTrue(!event.results);
		}
		
	
		[Test(async)]
		/**
		 * test the constraint against email containing invalid char
		 */
		public function validationFailInvalidChar():void {
			testItem.stringProperty = "ema(l@domain.com";
			emailConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailInvalidCharComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationFailInvalidCharComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"invalidChar");
		}
		
		
		
		[Test(async)]
		/**
		 * test the constraint against email containing invalid domain
		 */
		public function validationFailinvalidDomain():void {
			testItem.stringProperty = "email@domain.c";
			emailConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailinvalidDomainComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationFailinvalidDomainComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"invalidDomain");
		}
		
		
		
		[Test(async)]
		/**
		 * test the constraint against email containing invalid ipdomain
		 */
		public function validationFailInvalidIPDomain():void {
			testItem.stringProperty = "email@[91.23.33]";
			emailConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailInvalidIPDomainComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationFailInvalidIPDomainComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"invalidIPDomain");
		}
		
		
		
		[Test(async)]
		public function validationFailinvalidPeriodsInDomain():void {
			testItem.stringProperty = "email@domain..com";
			emailConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailinvalidPeriodsInDomainComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationFailinvalidPeriodsInDomainComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"invalidPeriodsInDomain");
		}
		
		
		
		[Test(async)]
		public function validationFailMissingAt():void {
			testItem.stringProperty = "emaildomain.com";
			emailConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailMissingAtComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationFailMissingAtComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"missingAtSign");
		}
		
	
		
		[Test(async)]
		public function validationFailMissingPeriodInDomain():void {
			testItem.stringProperty = "email@domain";
			emailConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailMissingPeriodInDomainComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationFailMissingPeriodInDomainComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"missingPeriodInDomain");
		}
		
		
		
		[Test(async)]
		public function validationFailMissingUsername():void {
			testItem.stringProperty = "@domain.com";
			emailConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailMissingUsernameComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationFailMissingUsernameComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"missingUsername");
		}
		
		
		
	
		
		[Test(async)]
		public function validationFailTooManyAt():void {
			testItem.stringProperty = "email@@domain.com";
			emailConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailTooManyAtComplete, 20, null, handle_Timeout));
			emailConstraint.validate(testItem);
		}
		
		public function handle_validationFailTooManyAtComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"tooManyAtSigns");
		}
		
		public function handle_Timeout(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
		
		
		
	}
}