package com.unikity.jabikityx.privatestorage
{
	import flash.events.Event;
	
	public class PrivateStorageEvent extends Event
	{
		public static const DATA_STORED:String = "privateStorageDataStored";
		public static const DATA_RECEIVED:String = "privateStorageDataReceived";		
		public static const ERROR:String = "privateStorageError";
		
		public var data:*;
		
		public function PrivateStorageEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}

		override public function clone():Event
		{
			return new PrivateStorageEvent(type, bubbles, cancelable);
		}
	}
}