package com.deCampredon.flexAcacia.validation.sample.presentation
{
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	import com.deCampredon.flexAcacia.validation.core.ValidationSession;
	import com.deCampredon.flexAcacia.validation.sample.domain.User;
	import com.deCampredon.flexAcacia.validation.sample.validation.UserValidationModel;
	
	import mx.controls.Alert;
	import mx.events.ValidationResultEvent;
	import com.deCampredon.flexAcacia.validation.sample.validation.UserFormValiationModel;
	

	[Bindable]
	public class UserFormPM
	{
		public function UserFormPM()
		{
			user = new User();
		}
		
		public var validationModel:ValidationModel = new UserFormValiationModel();
		
		public var user:User;
		
		public var password:String;
		
		public var confirm:String;
		
		public function save():void {
			var session:ValidationSession = validationModel.newValidationSession(this);
			session.startValidation();
			var event:ValidationResultEvent = session.resultEvent;
			if(event.type == ValidationResultEvent.VALID) {
				//do saving
				Alert.show("User have been saved","Save Complete");
			}
		}
	}
}