package com.deCampredon.flexAcacia.validation.test.subscribers
{
	import flash.events.EventDispatcher;
	
	import mx.events.ValidationResultEvent;
	import mx.validators.IValidatorListener;
	
	public class MockValidatorListener extends EventDispatcher implements IValidatorListener
	{
		public function MockValidatorListener()
		{
		}
		
		public function get errorString():String
		{
			return null;
		}
		
		public function set errorString(value:String):void
		{
		}
		
		public function get validationSubField():String
		{
			return null;
		}
		
		public function set validationSubField(value:String):void
		{
		}
		
		public function validationResultHandler(event:ValidationResultEvent):void
		{
		}
	}
}