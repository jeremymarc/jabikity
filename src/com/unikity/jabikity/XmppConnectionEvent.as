package com.unikity.jabikity
{
	import flash.events.Event;
	
	public class XmppConnectionEvent extends Event
	{		
		public static const CONNECT:String = "xmppConnectionConnect";
		public static const DISCONNECT:String = "xmppConnectionDisconnect";
	
		public static const AUTHENTICATION_SUCCESS:String = "xmppConnectionAuthenticationSuccess";
		public static const AUTHENTICATION_FAILED:String = "xmppConnectionAuthenticationFailed";
		public static const AUTHENTICATION_ERROR:String = "xmppConnectionAuthenticationError";
		
		public static const READY:String = "xmppConnectionReady";
		
		public static const SEND_DATA:String = "xmppConnectionSendData";
		public static const RECEIVE_DATA:String = "xmppConnectionReceiveData";
		
		public static const ERROR:String = "xmppConnectionError";
		
		public var data:*;
		
		public function XmppConnectionEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}

		override public function clone():Event
		{
			return new XmppConnectionEvent(type, bubbles, cancelable);
		}
	}
}