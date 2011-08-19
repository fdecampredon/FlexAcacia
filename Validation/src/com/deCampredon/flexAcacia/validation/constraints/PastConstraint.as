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
	
	import mx.events.ValidationResultEvent;
	import mx.resources.ResourceManager;
	import mx.validators.ValidationResult;
	
	[ResourceBundle("validation")]
	
	[Metadata(name="Past",types="property", multiple="true")]
	/**
	 * the PastConstraint allow you to validate that a date
	 * property is in the Past
	 * 
	 * @author François de Campredon
	 */
	public class PastConstraint extends AbstractConstraint
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function PastConstraint()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  strict
		//----------------------------------
		
		/**
		 * Specifies if present date represent a valid value
		 */
		public var strict:Boolean;
		
		
		//----------------------------------
		//  includeTime
		//----------------------------------
		
		/**
		 * Specifies if time should be used for validation
		 */
		public var includeTime:Boolean;
		
		
		//----------------------------------
		//  errorMessageBundle
		//----------------------------------
		/**
		 * the bundle used to retrieve  message when validation fail,
		 * if the <code>errorMessage</code> property is set, this property
		 * will be ignored.
		 * @default "validators"
		 */
		public var errorMessageBundle:String = "validation";
		
		
		//----------------------------------
		//  errorMessageKey
		//----------------------------------
		/**
		 * the key used to retrieve message when validation fail
		 * if the <code>errorMessage</code> property is set, this property
		 * will be ignored.
		 * @default "noMatchError"
		 */
		public var errorMessageKey:String = "tooLateError";
		
		//----------------------------------
		//  errorMessage
		//----------------------------------
		/**
		 * error message used when validation fail, if this property
		 * is set, <code>errorMessageBundle</code> bundle and
		 * <code>errorMessageKey</code> will be ignored
		 */
		public var errorMessage:String;
		
		
		/**
		 * @inheritDoc
		 */
		override public function validate(target:Object):void
		{
			var value:Date = PropertyUtil.getFieldValue(target,field);
			if(value) {
				var validationDate:Date = new Date();
				if(!includeTime)
					validationDate.setHours(0,0,0,0);
				if((strict && value.time >= validationDate.time) || (!strict && value.time > validationDate.time)) {
					dispatchValidationResulEvent(ValidationResultEvent.INVALID,[new ValidationResult(
						true,
						field,
						"tooLate",
						getErrorMessage()
					)])
				}
				
			}
			dispatchValidationResulEvent(ValidationResultEvent.VALID);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Internal Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 */
		private function getErrorMessage():String {
			return errorMessage?errorMessage:ResourceManager.getInstance().getString(errorMessageBundle,errorMessageKey);
		}
	}
}