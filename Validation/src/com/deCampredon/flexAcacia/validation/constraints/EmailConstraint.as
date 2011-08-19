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
	import mx.validators.ValidationResult;
	
	
	[Metadata(name="Email",types="property", multiple="true")]
	/**
	 * the EmailConstraint allow you to validate that a property
	 * have a valid email address format
	 * 
	 * @author François de Campredon
	 */
	public class EmailConstraint extends AbstractConstraint
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function EmailConstraint()
		{
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private static const DISALLOWED_LOCALNAME_CHARS:String =
			"()<>,;:\\\"[] `~!#$%^&*={}|/?'";
		/**
		 *  @private
		 */							
		private static const DISALLOWED_DOMAIN_CHARS:String =
			"()<>,;:\\\"[] `~!#$%^&*+={}|/?'";
		
		/**
		 * Validate a given IP address
		 * 
		 * If IP domain, then must follow [x.x.x.x] format
		 * or for IPv6, then follow [x:x:x:x:x:x:x:x] or [x::x:x:x] or some
		 * IPv4 hybrid, like [::x.x.x.x] or [0:00::192.168.0.1]
		 *
		 * @private
		 */ 
		private static function isValidIPAddress(ipAddr:String):Boolean
		{
			var ipArray:Array = [];
			var pos:int = 0;
			var newpos:int = 0;
			var item:Number;
			var n:int;
			var i:int;
			
			// if you have :, you're in IPv6 mode
			// if you have ., you're in IPv4 mode
			
			if (ipAddr.indexOf(":") != -1)
			{
				// IPv6
				
				// validate by splitting on the colons
				// to make it easier, since :: means zeros, 
				// lets rid ourselves of these wildcards in the beginning
				// and then validate normally
				
				// get rid of unlimited zeros notation so we can parse better
				var hasUnlimitedZeros:Boolean = ipAddr.indexOf("::") != -1;
				if (hasUnlimitedZeros)
				{
					ipAddr = ipAddr.replace(/^::/, "");
					ipAddr = ipAddr.replace(/::/g, ":");
				}
				
				while (true)
				{
					newpos = ipAddr.indexOf(":", pos);
					if (newpos != -1)
					{
						ipArray.push(ipAddr.substring(pos,newpos));
					}
					else
					{
						ipArray.push(ipAddr.substring(pos));
						break;
					}
					pos = newpos + 1;
				}
				
				n = ipArray.length;
				
				const lastIsV4:Boolean = ipArray[n-1].indexOf(".") != -1;
				
				if (lastIsV4)
				{
					// if no wildcards, length must be 7
					// always, never more than 7
					if ((ipArray.length != 7 && !hasUnlimitedZeros) || (ipArray.length > 7))
						return false;
					
					for (i = 0; i < n; i++)
					{
						if (i == n-1)
						{
							// IPv4 part...
							return isValidIPAddress(ipArray[i]);
						}
						
						item = parseInt(ipArray[i], 16);
						
						if (item != 0)
							return false;
					}
				}
				else
				{
					
					// if no wildcards, length must be 8
					// always, never more than 8
					if ((ipArray.length != 8 && !hasUnlimitedZeros) || (ipArray.length > 8))
						return false;
					
					for (i = 0; i < n; i++)
					{
						item = parseInt(ipArray[i], 16);
						
						if (isNaN(item) || item < 0 || item > 0xFFFF)
							return false;
					}
				}
				
				return true;
			}
			
			if (ipAddr.indexOf(".") != -1)
			{
				// IPv4
				
				// validate by splling on the periods
				while (true)
				{
					newpos = ipAddr.indexOf(".", pos);
					if (newpos != -1)
					{
						ipArray.push(ipAddr.substring(pos,newpos));
					}
					else
					{
						ipArray.push(ipAddr.substring(pos));
						break;
					}
					pos = newpos + 1;
				}
				
				if (ipArray.length != 4)
					return false;
				
				n = ipArray.length;
				for (i = 0; i < n; i++)
				{
					item = Number(ipArray[i]);
					if (isNaN(item) || item < 0 || item > 255)
						return false;
				}
				
				return true;
			}
			
			return false;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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
		//  invalidCharError
		//----------------------------------
		
		/**
		 *  Error message when there are invalid characters in the e-mail address.
		 */
		public var invalidCharError:String;
		
		/**
		 * bundle used to replace the invalidDomainError message when it is not specified
		 */
		public var invalidCharErrorBundle:String;
		
		/**
		 * key used to replace the invalidDomainError message when it is not specified
		 * @default "invalidCharErrorEV"
		 */
		public var invalidCharErrorKey:String = "invalidCharErrorEV";
		
		
		//----------------------------------
		//  invalidDomainError
		//----------------------------------
		
		/**
		 *  Error message when the suffix (the top level domain)
		 *  is not 2, 3, 4 or 6 characters long.
		 */
		public var invalidDomainError:String;
		
		/**
		 * bundle used to replace the invalidDomainError message when it is not specified
		 */
		public var invalidDomainErrorBundle:String;
		
		/**
		 * key used to replace the invalidDomainError message when it is not specified
		 * @default "invalidDomainErrorEV"
		 */
		public var invalidDomainErrorKey:String = "invalidDomainErrorEV";
		
		
		//----------------------------------
		//  invalidIPDomainError
		//----------------------------------
		
		/**
		 *  Error message when the IP domain is invalid. The IP domain must be enclosed by square brackets.
		 */
		public var invalidIPDomainError:String
		
		/**
		 * bundle used to replace the invalidDomainError message when it is not specified
		 */
		public var invalidIPDomainErrorBundle:String;
		
		/**
		 * key used to replace the invalidDomainError message when it is not specified
		 * @default "invalidIPDomainError"
		 */
		public var invalidIPDomainErrorKey:String = "invalidIPDomainError";
		
		//----------------------------------
		//  invalidPeriodsInDomainError
		//----------------------------------
		
		/**
		 *  Error message when the IP domain is invalid. The IP domain must be enclosed by square brackets.
		 */
		public var invalidPeriodsInDomainError:String
		
		/**
		 * bundle used to replace the invalidDomainError message when it is not specified
		 */
		public var invalidPeriodsInDomainErrorBundle:String;
		
		/**
		 * key used to replace the invalidDomainError message when it is not specified
		 * @default "invalidPeriodsInDomainError"
		 */
		public var invalidPeriodsInDomainErrorKey:String = "invalidPeriodsInDomainError";
		
		//----------------------------------
		//  missingAtSignError
		//----------------------------------
		
		/**
		 *  Error message when there is no at sign in the email address.
		 */
		public var missingAtSignError:String
		
		/**
		 * bundle used to replace the invalidDomainError message when it is not specified
		 */
		public var missingAtSignErrorBundle:String;
		
		/**
		 * key used to replace the invalidDomainError message when it is not specified
		 * @default "missingAtSignError"
		 */
		public var missingAtSignErrorKey:String = "missingAtSignError";
		
		//----------------------------------
		//  missingPeriodInDomainError
		//----------------------------------
		/**
		 * Error message when there is no period in the domain.
		 */
		public var missingPeriodInDomainError:String
		
		/**
		 * bundle used to replace the invalidDomainError message when it is not specified
		 */
		public var missingPeriodInDomainErrorBundle:String;
		
		/**
		 * key used to replace the invalidDomainError message when it is not specified
		 * @default "missingPeriodInDomainError"
		 */
		public var missingPeriodInDomainErrorKey:String = "missingPeriodInDomainError";
		//----------------------------------
		//  missingUsernameError
		//----------------------------------
		
		/**
		 *  Error message when there is no username.
		 */
		public var missingUsernameError:String
		
		/**
		 * bundle used to replace the invalidDomainError message when it is not specified
		 */
		public var missingUsernameErrorBundle:String;
		
		/**
		 * key used to replace the invalidDomainError message when it is not specified
		 * @default "missingUsernameError"
		 */
		public var missingUsernameErrorKey:String = "missingUsernameError";
		
		//----------------------------------
		//  tooManyAtSignsError
		//----------------------------------
		
		/**
		 *  Error message when there is more than one at sign in the e-mail address.
		 *  This property is optional. 
		 */
		public var tooManyAtSignsError:String
		
		/**
		 * bundle used to replace the tooManyAtSignsError message when it is not specified
		 */
		public var tooManyAtSignsErrorBundle:String
		
		/**
		 * key used to replace the tooManyAtSignsError message when it is not specified
		 * @default "tooManyAtSignsError"
		 */
		public var tooManyAtSignsErrorKey:String = "tooManyAtSignsError"
	
		
		
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
			var emailStr:String = String(value);
			var username:String = "";
			var domain:String = "";
			var n:int;
			var i:int;
			
			// Find the @
			var ampPos:int = emailStr.indexOf("@");
			if (ampPos == -1)
			{
				dispatchValidationResulEvent(ValidationResultEvent.INVALID,
					[new ValidationResult(true, field, "missingAtSign",getMissingAtSignError())]);
				return;
			}
				// Make sure there are no extra @s.
			else if (emailStr.indexOf("@", ampPos + 1) != -1) 
			{ 
				dispatchValidationResulEvent(ValidationResultEvent.INVALID,
					[new ValidationResult(true, field, "tooManyAtSigns",getTooManyAtSignsError())]);
			}
			
			// Separate the address into username and domain.
			username = emailStr.substring(0, ampPos);
			domain = emailStr.substring(ampPos + 1);
			
			// Validate username has no illegal characters
			// and has at least one character.
			var usernameLen:int = username.length;
			if (usernameLen == 0)
			{
				dispatchValidationResulEvent(ValidationResultEvent.INVALID,
					[new ValidationResult(true, field, "missingUsername",getMissingUsernameError())]);
				return;
			}
			
			for (i = 0; i < usernameLen; i++)
			{
				if (DISALLOWED_LOCALNAME_CHARS.indexOf(username.charAt(i)) != -1)
				{
					dispatchValidationResulEvent(ValidationResultEvent.INVALID,
						[new ValidationResult(true, field, "invalidChar",invalidCharError)]);
					return;
				}
			}
			
			var domainLen:int = domain.length;
			
			// check for IP address
			if ((domain.charAt(0) == "[") && (domain.charAt(domainLen - 1) == "]"))
			{
				// Validate IP address
				if (!isValidIPAddress(domain.substring(1, domainLen - 1)))
				{
					dispatchValidationResulEvent(ValidationResultEvent.INVALID,
						[new ValidationResult(true, field, "invalidIPDomain",getInvalidIPDomainError())]);
					return;
				}
			}
			else
			{
				// Must have at least one period
				var periodPos:int = domain.indexOf(".");
				var nextPeriodPos:int = 0;
				var lastDomain:String = "";
				
				if (periodPos == -1)
				{
					dispatchValidationResulEvent(ValidationResultEvent.INVALID,
						[new ValidationResult(true, field, "missingPeriodInDomain",getMissingPeriodInDomainError())]);
					return;
				}
				
				while (true)
				{
					nextPeriodPos = domain.indexOf(".", periodPos + 1);
					if (nextPeriodPos == -1)
					{
						lastDomain = domain.substring(periodPos + 1);
						if (lastDomain.length != 3 &&
							lastDomain.length != 2 &&
							lastDomain.length != 4 &&
							lastDomain.length != 6)
						{
							dispatchValidationResulEvent(ValidationResultEvent.INVALID,
								[new ValidationResult(true, field, "invalidDomain",getInvalidDomainError())]);
							return;
						}
						break;
					}
					else if (nextPeriodPos == periodPos + 1)
					{
						dispatchValidationResulEvent(ValidationResultEvent.INVALID,
							[new ValidationResult(true, field, "invalidPeriodsInDomain",getInvalidPeriodsInDomainError())]);
						return;
					}
					periodPos = nextPeriodPos;
				}
				
				// Check that there are no illegal characters in the domain.
				for (i = 0; i < domainLen; i++)
				{
					if (DISALLOWED_DOMAIN_CHARS.indexOf(domain.charAt(i)) != -1)
					{
						dispatchValidationResulEvent(ValidationResultEvent.INVALID,
							[new ValidationResult(true, field, "invalidChar",getInvalidCharError())]);
						return;
					}
				}
				
				// Check that the character immediately after the @ is not a period.
				if (domain.charAt(0) == ".")
				{
					dispatchValidationResulEvent(ValidationResultEvent.INVALID,
						[new ValidationResult(true, field, "invalidDomain",getInvalidDomainError())]);
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
		private function getInvalidCharError():String
		{
			if(invalidCharError) {
				return invalidCharError;
			}
			else if(invalidCharErrorBundle && invalidCharErrorKey) {
				return  ResourceManager.getInstance().getString(invalidCharErrorBundle,invalidCharErrorKey);
			}
			else if(bundle && invalidCharErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,invalidCharErrorKey);
			}
			return null;
		}
		
		/**
		 * @private
		 */
		private function getInvalidDomainError():String
		{
			if(invalidDomainError) {
				return invalidDomainError;
			}
			else if(invalidDomainErrorBundle && invalidDomainErrorKey) {
				return  ResourceManager.getInstance().getString(invalidDomainErrorBundle,invalidDomainErrorKey);
			}
			else if(bundle && invalidDomainErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,invalidDomainErrorKey);
			}
			return null;
		}
		
		/**
		 * @private
		 */
		private function getInvalidIPDomainError():String
		{
			if(invalidIPDomainError) {
				return invalidIPDomainError;
			}
			else if(invalidIPDomainErrorBundle && invalidIPDomainErrorKey) {
				return  ResourceManager.getInstance().getString(invalidIPDomainErrorBundle,invalidIPDomainErrorKey);
			}
			else if(bundle && invalidIPDomainErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,invalidIPDomainErrorKey);
			}
			return null;
		}
		
		
		/**
		 * @private
		 */
		private function getInvalidPeriodsInDomainError():String
		{
			if(invalidPeriodsInDomainError) {
				return invalidPeriodsInDomainError;
			}
			else if(invalidPeriodsInDomainErrorBundle && invalidPeriodsInDomainErrorKey) {
				return  ResourceManager.getInstance().getString(invalidPeriodsInDomainErrorBundle,invalidPeriodsInDomainErrorKey);
			}
			else if(bundle && invalidPeriodsInDomainErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,invalidPeriodsInDomainErrorKey);
			}
			return null;
		}
		
		
		
		/**
		 * @private
		 */
		private function getMissingAtSignError():String
		{
			if(missingAtSignError) {
				return missingAtSignError;
			}
			else if(missingAtSignErrorBundle && missingAtSignErrorKey) {
				return  ResourceManager.getInstance().getString(missingAtSignErrorBundle,missingAtSignErrorKey);
			}
			else if(bundle && missingAtSignErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,missingAtSignErrorKey);
			}
			return null;
		}
		
		
		
		/**
		 * @private
		 */
		private function getMissingPeriodInDomainError():String
		{
			if(missingPeriodInDomainError) {
				return missingPeriodInDomainError;
			}
			else if(missingPeriodInDomainErrorBundle && missingPeriodInDomainErrorKey) {
				return  ResourceManager.getInstance().getString(missingPeriodInDomainErrorBundle,missingPeriodInDomainErrorKey);
			}
			else if(bundle && missingPeriodInDomainErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,missingPeriodInDomainErrorKey);
			}
			return null;
		}
		
		/**
		 * @private
		 */
		private function getMissingUsernameError():String
		{
			if(missingUsernameError) {
				return missingUsernameError;
			}
			else if(missingUsernameErrorBundle && missingUsernameErrorKey) {
				return  ResourceManager.getInstance().getString(missingUsernameErrorBundle,missingUsernameErrorKey);
			}
			else if(bundle && missingUsernameErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,missingUsernameErrorKey);
			}
			return null;
		}
		
		/**
		 * @private
		 */
		private function getTooManyAtSignsError():String
		{
			if(tooManyAtSignsError) {
				return tooManyAtSignsError;
			}
			else if(tooManyAtSignsErrorBundle && tooManyAtSignsErrorKey) {
				return  ResourceManager.getInstance().getString(tooManyAtSignsErrorBundle,tooManyAtSignsErrorKey);
			}
			else if(bundle && tooManyAtSignsErrorKey) {
				return  ResourceManager.getInstance().getString(bundle,tooManyAtSignsErrorKey);
			}
			return null;
		}
		
	}
}