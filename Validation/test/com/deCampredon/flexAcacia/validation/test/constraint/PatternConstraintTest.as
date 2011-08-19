package com.deCampredon.flexAcacia.validation.test.constraint
{
	import com.deCampredon.flexAcacia.validation.constraints.PatternConstraint;
	
	import mx.events.ValidationResultEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	public class PatternConstraintTest
	{
		
		public var testItem:ConstraintTestItem;
		public var patternConstraint:PatternConstraint;
		
		[Before]
		public function setUp():void
		{
			testItem = new ConstraintTestItem();
			
			
			patternConstraint = new PatternConstraint();
			patternConstraint.field = "stringProperty";
			patternConstraint.expression = "^[a-z]*$";
			patternConstraint.flags = "i";
			
		}
		
		[Test(async)]
		/**
		 * test than the constraint against a valid email
		 */
		public function validationSuccess():void {
			testItem.stringProperty = "hello";
			patternConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			patternConstraint.validate(testItem);
		}	
		
		
		[Test(async)]
		public function validationFail():void {
			testItem.stringProperty = "780";
			patternConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailComplete, 20, null, handle_Timeout));
			patternConstraint.validate(testItem);
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
			assertEquals(event.results[0].errorCode,'noMatch');
		}
		
		/**
		 * Handle timeout
		 */
		protected function handle_Timeout(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
	}
}