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
	
	import com.deCampredon.flexAcacia.validation.utils.PropertyUtil;
	
	import flash.events.EventDispatcher;
	
	import mx.events.ValidationResultEvent;
	import com.deCampredon.flexAcacia.validation.core.Constraint;
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	import com.deCampredon.flexAcacia.validation.core.ValidationSession;
	
	
	[Metadata(name="SubValidationTarget",types="property", multiple="true")]
	
	/**
	 * The SubValidationTarget allow you to use a sub ValidationModel
	 */
	public class SubValidationTarget extends EventDispatcher implements Constraint
	{
		
	
		
		//--------------------------------------------------------------------------
		//
		//  constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 */
		public function SubValidationTarget()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  validationModel
		//----------------------------------
		
		/**
		 * The <code>ValidationModel</code> of the property.
		 */
		public var validationModel:ValidationModel;
		
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
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function validate(target:Object):void
		{
			var value:* = PropertyUtil.getFieldValue(target,field);
			var validationSession:ValidationSession = validationModel.newValidationSession(value);
			validationSession.addEventListener(ValidationResultEvent.VALID,validationResultHandler);
			validationSession.addEventListener(ValidationResultEvent.INVALID,validationResultHandler);
			validationSession.startValidation();
		}
		
		/**
		 * @inheritDoc
		 */
		protected function validationResultHandler(event:ValidationResultEvent):void
		{
			event.field = this.field;
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():Constraint {
			var subValidator:SubValidationTarget = new SubValidationTarget();
			subValidator.field = field;
			subValidator.groups = groups?groups.concat():null;
			subValidator.validationModel = validationModel?validationModel.clone():null;
			return subValidator;
		}
	}
}