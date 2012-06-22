package com.unikity.netkity.authenticator
{
	import flash.events.Event;
	
	public class AuthenticatorEvent extends Event
	{
		public static const AUTHENTICATION_SUCCESS:String = "authenticationSuccess";
		public static const AUTHENTICATION_FAIL:String = "authenticationFail";
		public static const AUTHENTICATION_ERROR:String = "authenticationError";
		
		public var data:*;
		
		public function AuthenticatorEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}

		override public function clone():Event
		{
			return new AuthenticatorEvent(type, bubbles, cancelable);
		}
	}
}