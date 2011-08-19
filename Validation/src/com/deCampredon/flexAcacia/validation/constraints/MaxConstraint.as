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
	
	[Metadata(name="Max",types="property")]
	/**
	 * the MaxConstraint allow you to validate numeric value 
	 * against a Maximum
	 * 
	 * @author François de Campredon
	 */
	public class MaxConstraint extends AbstractConstraint
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function MaxConstraint()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Max
		//----------------------------------
		
		/**
		 * the Maximum length authorized, if omited 
		 * will not be include in the validation proccess
		 */
		public var max:Number;
		
		//----------------------------------
		//  strict
		//----------------------------------
		
		/**
		 * Specifies if the value should be strictly inferior to
		 * the <code>max</code> property or not
		 */
		public var strict:Boolean;
		
		//----------------------------------
		//  errorMessageBundle
		//----------------------------------
		/**
		 * the bundle used to retrieve  message when validation fail,
		 * if the <code>errorMessage</code> property is set, this property
		 * will be ignored.
		 * @default "validators"
		 */
		public var errorMessageBundle:String = "validators";
		
		//----------------------------------
		//  errorMessageKey
		//----------------------------------
		/**
		 * the key used to retrieve message when validation fail
		 * if the <code>errorMessage</code> property is set, this property
		 * will be ignored.
		 * @default "noMatchError"
		 */
		public var errorMessageKey:String = "exceedsMaxError";
		
		//----------------------------------
		//  errorMessage
		//----------------------------------
		/**
		 * error message used when validation fail, if this property
		 * is set, <code>errorMessageBundle</code> bundle and
		 * <code>errorMessageKey</code> will be ignored
		 */
		public var errorMessage:String;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function validate(target:Object):void
		{
			var value:* = PropertyUtil.getFieldValue(target,field);
			if(value && !isNaN(value) && !isNaN(max) && ((strict && value >= max) || (!strict && value > max) )) {
				dispatchValidationResulEvent(ValidationResultEvent.INVALID,[new ValidationResult(
					true,
					field,
					"exceedsMax",
					getErrorMessage()
				)])
				return;
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