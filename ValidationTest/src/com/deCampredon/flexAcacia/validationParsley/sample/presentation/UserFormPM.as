package com.deCampredon.flexAcacia.validationParsley.sample.presentation
{
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	import com.deCampredon.flexAcacia.validation.core.ValidationSession;
	import com.deCampredon.flexAcacia.validationParsley.sample.domain.User;
	
	import mx.controls.Alert;
	import mx.events.ValidationResultEvent;
	
	import org.spicefactory.lib.reflect.ClassInfo;

	[Bindable]
	[Assert(field="passwordConfirm",expression="password==confirm",
			errorMessage="password and confirmation must be equals")]
	public class UserFormPM
	{
		public function UserFormPM()
		{
			
			user = new User();
		}
		
		
		[SubValidationTarget]
		public var user:User;
		
		[Size(min="8",max="255")]
		[Pattern(expression=".*[a-z].*",flags="i",errorMessage="password must contain letter")]
		[Pattern(expression=".*[0-9].*",errorMessage="password must contain digit")]
		[NotNull]
		public var password:String;
		
		[NotNull]
		public var confirm:String;
		
		
		[isValid]
		public var isValid:Boolean;
		
		public function save():void {
			if(isValid) {
				//do saving
				Alert.show("User have been saved","Save Complete");
			}
		}
	}
}