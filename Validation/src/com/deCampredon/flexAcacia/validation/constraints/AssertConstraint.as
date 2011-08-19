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
	
	
	import mx.events.ValidationResultEvent;
	import mx.resources.ResourceManager;
	import mx.utils.ObjectUtil;
	import mx.validators.ValidationResult;
	
	import r1.deval.D;
	
	

	[Metadata(name="Assert",types="class", multiple="true")]
	/**
	 * Allow you to validate an object against an expression that will 
	 * be evaluated in context of the validation target
	 * 
	 * @author François de Campredon
	 */
	public class AssertConstraint extends AbstractConstraint
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * contructor
		 */
		public function AssertConstraint()
		{
			super();
		}
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  expression
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _expression:String;
		
		private var program:Object;
		
		[Required]
		/**
		 * the expression evaludated during validation
		 */
		public function get expression():String
		{
			return _expression;
		}
		
		/**
		 * @private
		 */
		public function set expression(value:String):void
		{
			_expression = value;
			if(expression) {
				try {
					program = D.parseProgram(_expression);	
				}
				catch(e:Error) {
					program = null;
				}
			}
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
		override public function validate(target:Object):void
		{
			if(target && program) {
				var context:Object ={};
				var properties:Array = ObjectUtil.getClassInfo(target).properties;
				for each(var property:String in properties) {
					context[property] = target[property];
				}
				try {
					var eval:Boolean = D.evalToBoolean(program,context,null);
					if(!eval) {
						dispatchValidationResulEvent(ValidationResultEvent.INVALID,[new ValidationResult(true,field,"assertionFalse",getErrorMessage())]);
					}
				}
				catch(e:Error) {
					throw new EvalError("expression '"+expression+"' could not have been evaluated");
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