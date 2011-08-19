package com.deCampredon.flexAcacia.validation.test.constraint
{
	import com.deCampredon.flexAcacia.validation.constraints.SizeConstraint;
	
	import mx.events.ValidationResultEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	public class SizeConstraintTest
	{
		
		public var testItem:ConstraintTestItem;
		public var sizeConstraint:SizeConstraint;
		
		[Before]
		public function setUp():void
		{
			testItem = new ConstraintTestItem();
			
			sizeConstraint = new SizeConstraint();
			sizeConstraint.field = "stringProperty";
			sizeConstraint.min = 5;
			sizeConstraint.max = 15;
			
		}
		
		[Test(async)]
		public function validationSuccess():void {
			testItem.stringProperty = "hello world";
			sizeConstraint.addEventListener(ValidationResultEvent.VALID,Async.asyncHandler(this, handle_validationSuccessComplete, 20, null, handle_Timeout));
			sizeConstraint.validate(testItem);
		}	
		
		
		[Test(async)]
		public function validationFailWhenTooShort():void {
			testItem.stringProperty="hey";
			sizeConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailTooShortComplete, 20, null, handle_Timeout));
			sizeConstraint.validate(testItem);
		}	
		
		[Test(async)]
		public function validationFailWhenTooLong():void {
			testItem.stringProperty= "hello world, my name is François";
			sizeConstraint.addEventListener(ValidationResultEvent.INVALID,Async.asyncHandler(this, handle_validationFailTooLongComplete, 20, null, handle_Timeout));
			sizeConstraint.validate(testItem);
		}	
		
		
		public function handle_validationSuccessComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertTrue(!event.results);
		}
		
		public function handle_validationFailTooShortComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"tooShort");
		}
		
		public function handle_validationFailTooLongComplete(event:ValidationResultEvent,passThroughData:Object):void {
			assertNotNull(event.results);
			assertEquals(event.results.length,1);
			assertEquals(event.results[0].errorCode,"tooLong");
		}
		
		/**
		 * Handle timeout
		 */
		public function handle_Timeout(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
		
	}
}