package com.deCampredon.flexAcacia.validation.test.constraint
{
	import com.deCampredon.flexAcacia.validation.constraints.MaxConstraint;
	
	import mx.events.ValidationResultEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	public class MaxConstraintTest
	{
		
		public var testItem:ConstraintTestItem;
		public var maxConstraint:MaxConstraint;
		
		[Before]
		public function setUp():void
		{
			testItem = new ConstraintTestItem();
			testItem.numberProperty = 5;
			
			maxConstraint = new MaxConstraint();
			maxConstraint.field = "numberProperty";
			
		}
		
		[Test(async)]
		/**
		 * test than the constraint against a valid email
		 */
		public function validationSuccess():void {
			maxConstraint.max = 10;
			maxConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			maxConstraint.validate(testItem);
		}	
		
		
		[Test(async)]
		public function validationFail():void {
			maxConstraint.max = 2;
			maxConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			maxConstraint.validate(testItem);
		}	
		
		[Test(async)]
		public function validationSucessWhenEqualsWithoutStrict():void {
			maxConstraint.max = 5;
			maxConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			maxConstraint.validate(testItem);
		}
		
		[Test(async)]
		public function validationFailWhenEqualsWithStrict():void {
			maxConstraint.max = 5;
			maxConstraint.strict = true;
			maxConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			maxConstraint.validate(testItem);
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
			assertEquals(event.results[0].errorCode,'exceedsMax');
		}
		
		/**
		 * Handle timeout
		 */
		protected function handle_Timeout(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
	
	}
}