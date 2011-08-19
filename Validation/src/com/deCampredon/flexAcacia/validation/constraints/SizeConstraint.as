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
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	
	[Metadata(name="Size",types="property")]
	/**
	 * the Size constraint allow you to validate the size 
	 * of a property (works against string, array, IList, 
	 * and any kind of object who posses a 'lenght' property)
	 * 
	 * @author François de Campredon
	 */
	public class SizeConstraint extends AbstractConstraint
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function SizeConstraint()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  min
		//----------------------------------
		
		/**
		 * the minimum length authorized, if omited 
		 * will not be include in the validation proccess
		 */
		public var min:Number;
		
		
		//----------------------------------
		//  max
		//----------------------------------
		
		/**
		 * the maximum length authorized, if omited 
		 * will not be include in the validation proccess
		 */
		public var max:Number;
		
		
		//----------------------------------
		//  bundle
		//----------------------------------
		/**
		 * the bundler used tro retrieve error message,
		 * this property will be ignored for each error with
		 * a specified error message
		 * @default "validators"
		 */
		public var bundle:String ="validators";
		
		//----------------------------------
		//  tooLongError
		//----------------------------------
		
		/**
		 *  Error message when there are invalid characters in the e-mail address.
		 */
		public var tooLongError:String;
		
		/**
		 * bundle used to replace the tooShortError message when it is not specified
		 */
		public var tooLongErrorBundle:String;
		
		/**
		 * key used to replace the tooShortError message when it is not specified
		 * @default "tooLongErrorEV"
		 */
		public var tooLongErrorKey:String = "tooLongError";
		
		
		//----------------------------------
		//  tooShortError
		//----------------------------------
		
		/**
		 *  Error message when the suffix (the top level domain)
		 *  is not 2, 3, 4 or 6 characters long.
		 */
		public var tooShortError:String;
		
		/**
		 * bundle used to replace the tooShortError message when it is not specified
		 */
		public var tooShortErrorBundle:String;
		
		/**
		 * key used to replace the tooShortError message when it is not specified
		 * @default "tooShortErrorEV"
		 */
		public var tooShortErrorKey:String = "tooShortError";
		
		
		
		
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
			if(value && value is Object && Object(value).hasOwnProperty("length")) {
				if(!isNaN(min) && value.length < min) {
					dispatchValidationResulEvent(ValidationResultEvent.INVALID,[new ValidationResult(
						true,
						field,
						"tooShort",
						StringUtil.substitute(getTooShortError(),min)
					)])
					return;
				}
				else if(!isNaN(max) && value.length > max) {
					dispatchValidationResulEvent(ValidationResultEvent.INVALID,[new ValidationResult(
						true,
						field,
						"tooLong",
						StringUtil.substitute(getTooLongError(),max)
					)])
					return;
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
		private function getTooLongError():String
		{
			if(tooLongError) {
				return tooLongError;
			}
			else if(tooLongErrorBundle && tooLongErrorKey) {
				return  ResourceManager.getInstance().getString(tooLongErrorBundle,tooLongErrorKey);
			}
			else if(bundle && tooLongErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,tooLongErrorKey);
			}
			return null;
		}
		
		/**
		 * @private
		 */
		private function getTooShortError():String
		{
			if(tooShortError) {
				return tooShortError;
			}
			else if(tooShortErrorBundle && tooShortErrorKey) {
				return  ResourceManager.getInstance().getString(tooShortErrorBundle,tooShortErrorKey);
			}
			else if(bundle && tooShortErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,tooShortErrorKey);
			}
			return null;
		}
	}
}