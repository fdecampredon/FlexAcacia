package com.deCampredon.flexAcacia.validation.test.constraint
{
	import com.deCampredon.flexAcacia.validation.constraints.MinConstraint;
	
	import mx.events.ValidationResultEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	public class MinConstraintTest
	{
		
		public var testItem:ConstraintTestItem;
		public var minConstraint:MinConstraint;
		
		[Before]
		public function setUp():void
		{
			testItem = new ConstraintTestItem();
			testItem.numberProperty = 5;
			
			minConstraint = new MinConstraint();
			minConstraint.field = "numberProperty";
			
		}
		
		[Test(async)]
		/**
		 * test than the constraint against a valid email
		 */
		public function validationSuccess():void {
			minConstraint.min = 2;
			minConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			minConstraint.validate(testItem);
		}	
		
		
		[Test(async)]
		public function validationFail():void {
			minConstraint.min = 10;
			minConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			minConstraint.validate(testItem);
		}	
		
		[Test(async)]
		public function validationSucessPresentWithoutStrict():void {
			minConstraint.min = 5;
			minConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			minConstraint.validate(testItem);
		}
		
		[Test(async)]
		public function validationFailPresentWithStrict():void {
			minConstraint.min = 5;
			minConstraint.strict = true;
			minConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			minConstraint.validate(testItem);
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
			assertEquals(event.results[0].errorCode,'lowerThanMin');
		}
		
		/**
		 * Handle timeout
		 */
		protected function handle_Timeout(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
	}
}