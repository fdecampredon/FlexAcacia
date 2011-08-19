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

package com.deCampredon.flexAcacia.validationParsley.subscribers
{
	import com.deCampredon.flexAcacia.validation.subscribers.AutoValidationSubscriber;
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import mx.events.FlexEvent;
	
	import org.spicefactory.lib.reflect.ClassInfo;
	import com.deCampredon.flexAcacia.validationParsley.MetadataValidatorModelFactory;
	
	/**
	 * @inheritDoc
	 * Generate the <code>ValidationModel</code> from target 
	 * class metadata if none are given.
	 * 
	 * @author François de Campredon
	 */	
	public class ParsleyAutoValidationSubscriber extends AutoValidationSubscriber
	{
		/**
		 * Constructor
		 */
		public function ParsleyAutoValidationSubscriber()
		{
			super();
		}
		
		
		/**
		 * @private
		 */
		private var _domain:ApplicationDomain = ApplicationDomain.currentDomain
		
		/**
		 * ApplicaitonDomain used to generate <code>ClassInfo</code>
		 * of the target
		 */
		public function set domain(value:ApplicationDomain):void
		{
			_domain = value;
			_generatedModelIsValid = false;
			invalidateSubscribers();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set target(value:Object):void {
			if(target == value)
				return;
			_generatedModelIsValid = false;
			super.target = value;
		}
		
		/**
		 * @private
		 */
		private var _generatedModelIsValid:Boolean;
		/**
		 * @private
		 */
		private var _generatedModel:ValidationModel;
		
		/**
		 * @inheritDoc
		 */
		override public function get validationModel():ValidationModel {
			var model:ValidationModel = super.validationModel;
			
			if(model) {
				return model;
			}
			else {
				generateModel();
				return _generatedModel
			}
		}
		
		
		/**
		 * @private
		 */
		private function generateModel():void
		{
			if(!_generatedModelIsValid && target) {
				_generatedModelIsValid = true
				try
				{
					_generatedModel = MetadataValidatorModelFactory.newValidationModel(ClassInfo.forInstance(target,_domain));
				} 
				catch(error:Error) 
				{
					_generatedModelIsValid = false;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialized(document:Object, id:String):void {
			super.initialized(document,id)
			if(document is DisplayObject) {
				DisplayObject(document).addEventListener(FlexEvent.INITIALIZE, viewInitialized);
			}
			
		}
		
		/**
		 * @private
		 */
		private function viewInitialized(event:Event):void
		{
			if(_generatedModelIsValid) {
				_generatedModelIsValid = false;
				invalidateSubscribers();
			}
		}
		
	}
}