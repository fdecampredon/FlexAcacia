package com.deCampredon.flexAcacia.validation.test.constraint
{
	import com.deCampredon.flexAcacia.validation.constraints.FutureConstraint;
	
	import mx.events.ValidationResultEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class FutureConstraintTest
	{
		
		public var testItem:ConstraintTestItem;
		public var futureConstraint:FutureConstraint;
		
		[Before]
		public function setUp():void
		{
			testItem = new ConstraintTestItem();
			futureConstraint = new FutureConstraint();
			futureConstraint.field = "dateProperty";
		}
		
		[Test(async)]
		/**
		 * test than the constraint against a valid email
		 */
		public function validationSuccess():void {
			testItem.dateProperty = new Date(2050,1,1);
			futureConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			futureConstraint.validate(testItem);
		}	
		
		
		[Test(async)]
		public function validationFail():void {
			testItem.dateProperty = new Date(0);
			futureConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			futureConstraint.validate(testItem);
		}	
		
		[Test(async)]
		public function validationSucessWithPresentWithoutStrict():void {
			testItem.dateProperty = new Date();
			futureConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			futureConstraint.validate(testItem);
		}
		
		[Test(async)]
		public function validationFailWithPresentWithStrict():void {
			testItem.dateProperty = new Date();
			futureConstraint.strict = true;
			futureConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			futureConstraint.validate(testItem);
		}	
		
			
		
		/**
		 * Handle validaton success 
		 */
		protected function handle_validationSuccessComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertTrue(!event.results);
		}
		
		/**
		 * Handle validaton failure
		 */
		protected function handle_validationFailComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,'tooEarly');
		}
		
		/**
		 * Handle timeout
		 */
		protected function handle_Timeout(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
	}
}