package com.deCampredon.flexAcacia.validationParsley.sample.domain
{
	[Bindable]
	public class User
	{
		[Size(min="2",max="50")]
		[NotNull]
		public var firstName:String;
		
		[Size(min="2",max="255")]
		[NotNull]
		public var lastName:String;
		
		[Past]
		public var birthDay:Date;
		
		[Email][NotNull]
		public var email:String;
		
		[Size(min="6",max="255")]
		[NotNull]
		public var userName:String;
	}
}