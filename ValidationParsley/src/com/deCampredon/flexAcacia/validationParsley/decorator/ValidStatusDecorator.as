/*
* Copyright 2011 François de Campredon
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

package com.deCampredon.flexAcacia.validationParsley.decorator
{
	import com.deCampredon.flexAcacia.validationParsley.processor.ValidStatusProcessor;
	
	import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
	import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
	
	[Metadata(name="isValid",types="property", multiple="true")]
	/**
	 * The ValidStatusDecorator allow you to observe if the decorated object
	 * is valid.
	 * 
	 * @author François de Campredon
	 */
	public class ValidStatusDecorator implements ObjectDefinitionDecorator
	{
		[Target]
		/**
		 * 
		 */
		public var property:String;
		
		/**
		 * List of validation field
		 */
		public var fields:Array;
		
		/**
		 * List of validation group
		 */
		public var groups:Array;
		
		/**
		 * If the validationDelay is 0, the validaion process
		 * is triggered at each changes occured, otherwise the validation
		 * will be triggered after x millesecond without a change occur
		 * 
		 * @default 0
		 */
		public var validationDelay:uint = 0;
		
		/**
		 * @inheritDoc
		 */
		public function decorate(builder:ObjectDefinitionBuilder):void
		{
			builder
			.lifecycle()
				.processorFactory(ValidStatusProcessor.newFactory(property,validationDelay,fields,groups));
		}
	}
}