package com.deCampredon.flexAcacia.validation.test.constraint
{
	import com.deCampredon.flexAcacia.validation.constraints.AssertConstraint;
	
	import mx.events.ValidationResultEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class AssertConstraintTest
	{
		public var testItem:ConstraintTestItem;
		public var assertConstraint:AssertConstraint;
		
		
		[Before]
		public function setUp():void
		{
			testItem = new ConstraintTestItem();
			assertConstraint = new AssertConstraint();
			assertConstraint.field = "testAssertConstraint";
			assertConstraint.errorMessage ="there is an error";
		}
		
		[Test(async)]
		/**
		 * Test Validation over basic false expression
		 */
		public function validationFail():void {
			assertConstraint.expression = "stringProperty==stringProperty2";
			testItem.stringProperty = "a string";
			testItem.stringProperty2 = "another string";
			assertConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			assertConstraint.validate(testItem);
		}
		
		
		[Test(async)]
		public function validationSuccess():void {
			assertConstraint.expression = "stringProperty==stringProperty2";
			testItem.stringProperty = "a string";
			testItem.stringProperty2 = "a string";
			assertConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			assertConstraint.validate(testItem);
		}
		
		[Test(async)]
		public function validationWithDate():void {
			assertConstraint.expression = "dateProperty.fullYear==(new Date()).fullYear";
			testItem.dateProperty = new Date();
			assertConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			assertConstraint.validate(testItem);
		}
		
		[Test(async)]
		public function validationWithMath():void {
			assertConstraint.expression = "Math.pow(numberProperty,2)==intProperty";
			testItem.numberProperty = 2;
			testItem.intProperty = 4;
			assertConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			assertConstraint.validate(testItem);
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
			assertEquals(event.results[0].errorCode,'assertionFalse');
		}
		
		/**
		 * Handle timeout
		 */
		protected function handle_Timeout(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
	}
}