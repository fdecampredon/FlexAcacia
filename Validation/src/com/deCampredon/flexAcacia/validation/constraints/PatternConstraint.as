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
	import mx.validators.RegExpValidator;
	import mx.validators.ValidationResult;

	[Metadata(name="Pattern",types="property", multiple="true")]
	/**
	 * Allow you to validate an object against an regular expression
	 * 
	 * @author François de Campredon
	 */
	public class PatternConstraint extends AbstractConstraint
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 */
		public function PatternConstraint()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * The RegExp used for validation
		 */
		private var regxp:RegExp;

		/**
		 * @private
		 */
		private function generateRegexp():void {
			if(expression) {
				regxp = new RegExp(expression,flags);
			}
		}
		
		//----------------------------------
		//  flags
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _flags:String
		
		/**
		 * flags used by the generated RegExp
		 */
		public function get flags():String
		{
			return _flags;
		}

		public function set flags(value:String):void
		{
			_flags = value;
			generateRegexp();
		}

		//----------------------------------
		//  expression
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _expression:String
		
		/**
		 * expression used by the generated RegExp
		 */
		public function get expression():String
		{
			return _expression;
		}

		public function set expression(value:String):void
		{
			_expression = value;
			generateRegexp();
			RegExpValidator
		}
		
		
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
		public var errorMessageKey:String = "noMatchError";
		
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
		override public function validate(target:Object):void {
			var value:* = PropertyUtil.getFieldValue(target,field);
			if(value && regxp) {
				if(!regxp.test(value)) {
					dispatchValidationResulEvent(ValidationResultEvent.INVALID,[
						new ValidationResult(
							true,
							field,
							"noMatch",
							getErrorMessage()
						)
					])
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