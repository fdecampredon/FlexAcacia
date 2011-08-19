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

package com.deCampredon.flexAcacia.validationParsley.processor
{
	import com.deCampredon.flexAcacia.validation.constraints.SubValidationTarget;
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	import com.deCampredon.flexAcacia.validation.core.ValidationSession;
	import com.deCampredon.flexAcacia.validationParsley.MetadataValidatorModelFactory;
	import com.deCampredon.flexAcacia.validationParsley.decorator.ValidStatusDecorator;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.ValidationResultEvent;
	
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Property;
	import org.spicefactory.lib.util.ClassUtil;
	import org.spicefactory.parsley.core.lifecycle.ManagedObject;
	import org.spicefactory.parsley.core.registry.ObjectProcessor;
	import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
	import org.spicefactory.parsley.processor.util.ObjectProcessorFactories;
	
	/**
	 * The Validation status processor listen to change over a target entity
	 * Then update a boolean property with the current validity
	 * 
	 * @author François de Campredon
	 */
	public class ValidStatusProcessor implements ObjectProcessor
	{
		
		
		/**
		 * @params target the ManagedObject
		 * @params targetProperty the property decorated
		 * @params validationDelay delay between validation process
		 * @params fields list of validation field
		 * @params group list of validation group
		 */
		public function ValidStatusProcessor(target:ManagedObject,targetProperty:String,validationDelay:uint,fields:Array,groups:Array) {
			this.target = IEventDispatcher(target.instance);
			this.targetProperty = targetProperty;
			this.validationDelay = validationDelay;
			this.fields = fields;
			this.groups =groups;
			info = target.definition.type;
			validatorDefinition = MetadataValidatorModelFactory.newValidationModel(info);
		}
		
		/**
		 * @inheritDoc
		 */
		public function preInit():void
		{
			watchers = [];
			var properties:Array = info.getProperties();
			var watchableProperties:Array  = getWatchableField(target,properties);
			for each(var fields:Array in watchableProperties) {
				watchers.push(ChangeWatcher.watch(target,fields,propertyChange))
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function postDestroy():void
		{
			for each(var changeWatcher:ChangeWatcher in watchers) {
				changeWatcher.unwatch();
			}
			watchers = null;
		}
		
		/**
		 * @private
		 */
		private var target:IEventDispatcher;
		
		/**
		 * @private
		 */
		private var targetProperty:String;
		
		/**
		 * @private
		 */
		private var validationDelay:uint;
		
		/**
		 * @private
		 */
		private var fields:Array;
		
		/**
		 * @private
		 */
		private var groups:Array;
		
		/**
		 * @private
		 */
		private var info:ClassInfo;
		
		/**
		 * @private
		 */
		private var watchers:Array;
		
		/**
		 * @private
		 */
		private var validatorDefinition:ValidationModel;
		
		/**
		 * @private
		 */
		private var timeOut:int = 0;
		
		/**
		 * @private
		 */
		private function getWatchableField(target:Object,properties:Array,baseField:Array=null):Array {
			if(!baseField)
				baseField = [];
			var result:Array = [];
			for each(var property:Property in properties) {
				if(ChangeWatcher.canWatch(target,property.name)) {
					var validStatusMetadata:Array = property.getMetadata(ValidStatusDecorator);
					if(validStatusMetadata && validStatusMetadata.length >0) {
						continue;
					}
					var subValidatorMetadata:Array = property.getMetadata(SubValidationTarget);
					if(subValidatorMetadata && subValidatorMetadata.length >0) {
						var subTarget:Object = property.getValue(target);
						if(!subTarget) {
							try {
								subTarget = property.type.newInstance([]);
							}
							catch(e:Error) {}
						}
						if(!subTarget) {
							//TODO loging
							continue;
						}
						result = result.concat(getWatchableField(subTarget,property.type.getProperties(),baseField.concat(property.name)));
					}
					else {
						result.push(baseField.concat(property.name))
					}
				}
			}
			return result;
		}
		
		private function propertyChange(event:Event):void {
			if(validationDelay > 0) {
				clearTimeout(timeOut);
				timeOut = setTimeout(startValidation,validationDelay);
			}
			else {
				startValidation();
			}
			
		}
		
		private function startValidation():void{
			var validationSession:ValidationSession =  validatorDefinition.newValidationSession(target,fields,groups);
			validationSession.addEventListener(ValidationResultEvent.VALID,validationResultHandler);
			validationSession.addEventListener(ValidationResultEvent.INVALID,validationResultHandler)
			validationSession.startValidation();
		}
		
		private function validationResultHandler(event:ValidationResultEvent):void
		{
			target[targetProperty] = (event.type == ValidationResultEvent.VALID);
			IEventDispatcher(event.currentTarget).removeEventListener(ValidationResultEvent.VALID,validationResultHandler);
			IEventDispatcher(event.currentTarget).removeEventListener(ValidationResultEvent.INVALID,validationResultHandler);
		}
		
		/**
		 * Create a new ObjectProcessorFactory capable of instancing a ValidStatusProcessor
		 */		
		public static function newFactory (targetProperty:String,validationDelay:uint,fields:Array=null,groups:Array=null) : ObjectProcessorFactory {
			var params:Array = [targetProperty,validationDelay, fields,groups];
			return ObjectProcessorFactories.newFactory(ValidStatusProcessor, params);
		}
	}
}