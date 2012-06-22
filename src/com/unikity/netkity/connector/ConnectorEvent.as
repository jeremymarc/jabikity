package com.unikity.netkity.connector
{
	import flash.events.Event;
	
	public class ConnectorEvent extends Event
	{
		public static const CONNECT:String = "connectorConnect";
		public static const DISCONNECT:String = "connectorDisconnect";
		public static const RECEIVE_DATA:String = "connectorReceiveData";
		public static const SEND_DATA:String = "connectorSendData";
		public static const ERROR:String = "connectorError";
		
		public var data:*;
		
		public function ConnectorEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}

		override public function clone():Event
		{
			return new ConnectorEvent(type, bubbles, cancelable);
		}
	}
}