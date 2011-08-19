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

package com.deCampredon.flexAcacia.validationParsley
{
	import com.deCampredon.flexAcacia.validation.constraints.SubValidationTarget;
	import com.deCampredon.flexAcacia.validation.constraints.AssertConstraint;
	import com.deCampredon.flexAcacia.validation.constraints.EmailConstraint;
	import com.deCampredon.flexAcacia.validation.constraints.FutureConstraint;
	import com.deCampredon.flexAcacia.validation.constraints.MaxConstraint;
	import com.deCampredon.flexAcacia.validation.constraints.MinConstraint;
	import com.deCampredon.flexAcacia.validation.constraints.NotNullConstraint;
	import com.deCampredon.flexAcacia.validation.constraints.PastConstraint;
	import com.deCampredon.flexAcacia.validation.constraints.PatternConstraint;
	import com.deCampredon.flexAcacia.validation.constraints.SizeConstraint;
	import com.deCampredon.flexAcacia.validationParsley.decorator.ValidStatusDecorator;
	
	import org.spicefactory.lib.reflect.Metadata;
	import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
	import org.spicefactory.parsley.flex.tag.builder.BootstrapConfigProcessor;
	
	/**
	 * initialize support of the validation library with parlsey
	 * 
	 * @author François de Campredon
	 */
	public class ValidationSupport implements BootstrapConfigProcessor
	{
		/**
		 * Constructor
		 */
		public function ValidationSupport() {
			initialize();
		}
		
		/**
		 * @private
		 */
		private static var initialized:Boolean = false;
		
		/**
		 * @private
		 */
		private static var  metadataList:Array = [
			SubValidationTarget,
			AssertConstraint,
			EmailConstraint,
			FutureConstraint,
			MaxConstraint,
			MinConstraint,
			NotNullConstraint,
			PastConstraint,
			PatternConstraint,
			SizeConstraint,
			ValidStatusDecorator
		]
		
		/**
		 * initialize the support of  the Validation library extension for Parsley.
		 */
		public static function initialize () : void {
			if (initialized) 
				return;
			
			for each(var metadata:Class in metadataList) {
				Metadata.registerMetadataClass(metadata);
			}
			
			
			initialized = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function processConfig (config:BootstrapConfig) : void {
			
		}
	}
}