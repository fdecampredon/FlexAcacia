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
	import com.deCampredon.flexAcacia.validation.core.Constraint;
	import com.deCampredon.flexAcacia.validation.constraints.SubValidationTarget;
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Property;
	
	/**
	 * Factory class responsible for creating ValidationModel from class metadata
	 * 
	 * @author François de Campredon
	 */
	public class MetadataValidatorModelFactory
	{
		//--------------------------------------------------------------------------
		//
		//  Private static Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  validationDefinitionRegistry
		//----------------------------------
		
		/**
		 * @private
		 * cache for ValidationModel
		 */
		private static var validationDefinitionRegistry:Object = {};
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Public static Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Create a ValidationModel from class metadata
		 * 
		 * @param info the ClassInfo of the Class used to create the ValidationModel
		 */
		public static function newValidationModel(info:ClassInfo):ValidationModel {
			
			//if cache does not contain a validation model for that type
			if(!validationDefinitionRegistry.hasOwnProperty(info.name)) {
				var constraints:Array =[];
				var metadatas:Array = info.getAllMetadata();
				
				//extract object based constraints
				for each (var metadata:Object in metadatas) {
					if(metadata is Constraint) {
						constraints.push(metadata);
					}
				}
				
				//extract properties based contraints
				var properties:Array = info.getProperties();
				for each (var property:Property in properties) {
					metadatas = property.getAllMetadata();
					for each (metadata in metadatas) {
						if(metadata is Constraint) {
							constraints.push(metadata);
							Constraint(metadata).field = property.name;
							if(metadata is SubValidationTarget) {
								SubValidationTarget(metadata).validationModel = newValidationModel(property.type);
							}
						}
					}
				}
				
				//cache the validation model
				validationDefinitionRegistry[info.name] = new ValidationModel(constraints);
			}

			return validationDefinitionRegistry[info.name].clone();
		}
		
		/**
		 * clear ValidationModel cache
		 */
		public static function clearCahe():void{
			validationDefinitionRegistry = {};
		}
	}
}