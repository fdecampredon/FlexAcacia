package com.deCampredon.flexAcacia.validation.test.core
{
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	import com.deCampredon.flexAcacia.validation.core.ValidationSession;
	
	import mx.events.ValidationResultEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class ValidationSessionTest
	{
		public var validationSession:ValidationSession;
		
		[Test(async)]
		public function testValidationSuccess():void {
			validationSession = new ValidationSession(new Object(),[
				new ValidMockConstraint(),
				new ValidMockConstraint()
			]);
			validationSession.addEventListener(ValidationResultEvent.VALID,
			Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			validationSession.startValidation();
		}
		
		
		[Test(async)]
		public function testValidationFail():void {
			validationSession = new ValidationSession(new Object(),[
				new ValidMockConstraint(),
				new InvalidMockConstraint()
			]);
			validationSession.addEventListener(ValidationResultEvent.INVALID,
			Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			validationSession.startValidation();
		}
		
		/**
		 * Handle validaton success 
		 */
		protected function handle_validationSuccessComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNull(event.results);
		}
		/**
		 * Handle validaton failure
		 */
		protected function handle_validationFailComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,'error');
		}
		
		/**
		 * Handle timeout
		 */
		protected function handle_Timeout(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
	}
}