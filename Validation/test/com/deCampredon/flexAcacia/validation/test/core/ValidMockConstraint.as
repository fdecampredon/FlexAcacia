package com.deCampredon.flexAcacia.validation.test.core
{
	import com.deCampredon.flexAcacia.validation.core.Constraint;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.events.ValidationResultEvent;
	
	public class ValidMockConstraint extends EventDispatcher  implements Constraint 
	{
		public function ValidMockConstraint()
		{
		}
		
		public function get field():String
		{
			return null;
		}
		
		public function set field(value:String):void
		{
		}
		
		public function set groups(value:Array):void
		{
		}
		
		public function get groups():Array
		{
			return null;
		}
		
		public function validate(target:Object):void
		{
			dispatchEvent(new ValidationResultEvent(ValidationResultEvent.VALID));
		}
		
		public function clone():Constraint
		{
			return null;
		}
		
	
	}
}