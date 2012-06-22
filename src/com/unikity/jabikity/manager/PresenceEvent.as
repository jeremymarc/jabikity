package com.unikity.jabikity.manager
{
	import com.unikity.jabikity.protocol.core.Presence;
	
	import flash.events.Event;
	
	public class PresenceEvent extends Event
	{
		public static const PRESENCE_AVAILABLE:String = "presenceAvailable";
		public static const PRESENCE_UNAVAILABLE:String = "presenceUnavailable";
		public static const PRESENCE_PROBE:String = "presenceProbe";
		public static const PRESENCE_SUBSCRIBE:String = "presenceSubscribe";
		public static const PRESENCE_UNSUBSCRIBE:String = "presenceUnsubscribe";
		public static const PRESENCE_SUBSCRIBED:String = "presenceSubscribed";
		public static const PRESENCE_UNSUBSCRIBED:String = "presenceUnsubcribed";
		public static const PRESENCE_ERROR:String = "presenceError";
		
		public var presence:Presence;
		
		public function PresenceEvent(type:String, presence:Presence, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.presence = presence;
		}

		override public function clone():Event
		{
			return new PresenceEvent(type, presence, bubbles, cancelable);
		}
	}
}