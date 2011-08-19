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

package com.deCampredon.flexAcacia.validation.utils
{

	/**
	 * Utility class
	 * 
	 * @author François de Campredon
	 */
	public class PropertyUtil
	{
		/**
		 * get complex field object value
		 * 
		 */
		public static function getFieldValue(object:Object,field:String):*
		{
			var currentValue:* = object;
			var split:Array = field.split(".");
			while(currentValue && split.length>0) {
				currentValue = currentValue[split.shift()]
			}
			return currentValue;
		}
	}
}