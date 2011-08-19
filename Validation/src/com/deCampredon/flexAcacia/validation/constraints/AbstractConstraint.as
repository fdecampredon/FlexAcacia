/*
* Copyright 2009 François de Campredon
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

package com.deCampredon.flexAcacia.validation.constraints
{
	import com.deCampredon.flexAcacia.validation.core.Constraint;
	
	import flash.events.EventDispatcher;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	
	import mx.events.ValidationResultEvent;
	import mx.utils.ObjectUtil;
	
	/**
	 *  Dispatched when validation succeeds.
	 *
	 *  @eventType mx.events.ValidationResultEvent.VALID 
	 *  
	 */
	[Event(name="valid", type="mx.events.ValidationResultEvent")]
	
	/** 
	 *  Dispatched when validation fails.
	 *
	 *  @eventType mx.events.ValidationResultEvent.INVALID 
	 *  
	 */
	[Event(name="invalid", type="mx.events.ValidationResultEvent")]
	
	/**
	 * Base class for Constraint object
	 * 
	 * @author François de Campredon
	 */	
	public class AbstractConstraint extends EventDispatcher implements Constraint
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor 
		 */		
		public function AbstractConstraint()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  field
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _field:String;
		
		/**
		 * @inheritDoc 
		 */		
		public function get field():String
		{
			return _field;
		}
		
		/**
		 * @private
		 */	
		public function set field(value:String):void
		{
			_field = value;
		}
		
		//----------------------------------
		//  groups
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _groups:Array;
		
		/**
		 * @inheritDoc 
		 */	
		public function get groups():Array
		{
			return _groups;
		}
		
		/**
		 * @private
		 */	
		public function set groups(value:Array):void
		{
			_groups = value;
		}
		
		

		//--------------------------------------------------------------------------
		//
		//  methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function  validate(target:Object):void
		{
			throw new Error("this method is abstract and should be overrided");
		}
		
		/**
		 * responsible for dispatching ValidationResultEvent
		 * @param type type of the event dispatched
		 * @param results, list of results dispached
		 */
		protected function dispatchValidationResulEvent(type:String,results:Array=null):void {
			dispatchEvent(new ValidationResultEvent(type,false,false,field,results));
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():Constraint{
			var classInfo:Object = ObjectUtil.getClassInfo(this,null,{includeReadOnly : false});
			var type:Class = getDefinitionByName(classInfo.name) as Class;
			var result:Constraint = new type() as Constraint;
			for each(var property:String in classInfo.properties) {
				result[property] = this[property];
			}
			return result;
		}
	}
}