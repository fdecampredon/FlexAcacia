package com.deCampredon.flexAcacia.validation.test.core
{
	import com.deCampredon.flexAcacia.validation.core.Constraint;
	
	import flash.events.Event;
	
	public class MockConstraint implements Constraint
	{
		public function MockConstraint(id:String,field:String,groups:Array) {
			this.id = id;
			this.field = field;
			this.groups = groups;
		}
		
		public var id:String;
		
		private var _field:String;
		public function get field():String
		{
			
			return _field;
		}
		
		
		public function set field(value:String):void
		{
			_field = value;
		}
		
		
		private var _groups:Array;
		public function get groups():Array
		{
			return _groups;
		}
		
		
		public function set groups(value:Array):void
		{
			_groups = value;
		}
		
		public function clone():Constraint
		{
			return new MockConstraint(id,field,groups);
		}
		
		public function validate(target:Object):void
		{
			
		}
		
		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
	}
}