package com.unikity.jabikityx.privacy
{
	import flash.events.Event;
	
	public class PrivacyEvent extends Event
	{
		public static const GETITEMS:String = "privacyGetItems";
		public static const ERROR:String = "privacyError";
		public static const ALREADY_BLOCKED:String = "privacyAlreadyBlocked";
		
		public var data:*;
		
		public function PrivacyEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}

		override public function clone():Event
		{
			return new PrivacyEvent(type, bubbles, cancelable);
		}
	}
}