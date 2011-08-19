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

package com.deCampredon.flexAcacia.validation.subscribers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import mx.core.Application;
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	import mx.validators.IValidatorListener;
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	
	
	/**
	 * Responsible of connecting a form to a ValidationModel
	 * 
	 * @author François de Campredon
	 */	
	public class AutoValidationSubscriber implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 */
		public function AutoValidationSubscriber()
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
		 */	
		private var _subscribers:Dictionary;
		
		/**
		 * @private 
		 */	
		private var _subscribersValid:Boolean;
		
		
		
		//----------------------------------
		//  validationModel
		//----------------------------------
		
		/**
		 * @private 
		 */	
		private var _validationModel:ValidationModel;
		
		/**
		 * ValidationModel used to validate the current form
		 */
		public function get validationModel():ValidationModel {
			return _validationModel;
		}
		public function set validationModel(value:ValidationModel):void
		{
			if( _validationModel !== value)
			{
				_validationModel = value;
				invalidateSubscribers();
			}
		}
		

		//----------------------------------
		//  target
		//----------------------------------
		
		private var _target:Object;
		
		/**
		 * @copy com.deCampredon.flexAcacia.validation.ValidationSubscriver#target
		 */	
		public function get target():Object
		{
			return _target;
		}
		
		public function set target(value:Object):void
		{
			if( _target !== value)
			{
				_target = value;
				invalidateSubscribers();
			}
		}
		
		
		
		//----------------------------------
		//  triggerEvent
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _triggerEvent:String = FlexEvent.VALUE_COMMIT;
		
		
		/**
		 * @copy com.deCampredon.flexAcacia.validation.ValidationSubscriver#triggerEvent
		 */	
		public function get triggerEvent():String
		{
			return _triggerEvent;
		}
		
		public function set triggerEvent(value:String):void
		{
			if( _triggerEvent !== value)
			{
				_triggerEvent = value;
				invalidateSubscribers();
			}
		}
		
		//----------------------------------
		//  trigger
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _trigger:IEventDispatcher;
		
		/**
		 * @copy com.deCampredon.flexAcacia.validation.ValidationSubscriver#trigger
		 */	
		public function get trigger():IEventDispatcher
		{
			return _trigger;
		}
		
		public function set trigger(value:IEventDispatcher):void
		{
			if( _trigger !== value)
			{
				_trigger = value;
				invalidateSubscribers();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * start the validation for all registred IValidatorListener
		 */
		public function validate():void {
			for(var item:* in _subscribers) {
				var validationSubscriber:ValidationSubscriber = _subscribers[item];
				validationSubscriber.validate();
			}
		}
		
		/**
		 * invalid the subscribers property
		 */
		protected function invalidateSubscribers():void {
			_subscribersValid = false;
		}
		
		/**
		 * update generated subscribers properties
		 */
		protected function updateSubsCriberValue():void
		{
			if(_subscribers) {
				for(var item:* in _subscribers) {
					var validationSubscriber:ValidationSubscriber = _subscribers[item];
					setSubscriberProperty(validationSubscriber);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  IMXMLObject implementation
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function initialized(document:Object, id:String):void
		{
			_subscribers = new Dictionary();
			if(document is DisplayObject) {
				(document as DisplayObject).addEventListener(Event.ADDED,childAdded);
				(document as DisplayObject).addEventListener(Event.REMOVED,childRemoved);
				(document as DisplayObject).addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handling
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Handle child adding in the current document.
		 * track the presence of validationSubField, and generate appropriate 
		 * ValidationSubscriber if needed
		 */
		protected function childAdded(event:Event):void
		{
			if(event.target is IValidatorListener && IValidatorListener(event.target).validationSubField) {
				var validationSubscriber:ValidationSubscriber = new ValidationSubscriber();
				validationSubscriber.source = event.target as IValidatorListener;
				setSubscriberProperty(validationSubscriber);
				_subscribers[event.target] = validationSubscriber;
			}
		}
		
		
		/**
		 * Handle child removing in the current document.
		 * clean corresponding ValidationSubscriber if needed
		 */
		protected function childRemoved(event:Event):void
		{
			if(_subscribers[event.target]) {
				delete _subscribers[event.target];
			}
		}
		
		
		/**
		 * @private
		 */
		private function onEnterFrame(event:Event):void
		{
			if(!_subscribersValid){
				_subscribersValid = true;
				updateSubsCriberValue();
			}
		}	
		
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function setSubscriberProperty(validationSubscriber:ValidationSubscriber):void
		{
			validationSubscriber.trigger = trigger;
			validationSubscriber.triggerEvent = triggerEvent;
			validationSubscriber.target = target;
			validationSubscriber.validationModel = validationModel;
		}
	}
}