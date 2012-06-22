package com.unikity.jabikity.listener
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;
	
	public class IQResponderListener implements ICollector
	{
		public static const COLLECTOR_ID:String = "IQResponderListener";
		
		protected var connection:XmppConnection;
		
		public function IQResponderListener(connection:XmppConnection)
		{
			this.connection = connection;
		}
				
		public function onRegister():void
		{
			trace("IQResponderListener registered.");
		}
		
		public function onUnregister():void
		{
			trace("IQResponderListener unregistered.");
		}
		
		public function filter(object:ISerializable):Boolean
		{
			if (!(object is IQ))
				return false;
				
			var iq:IQ = object as IQ;
			
			return iq.type == IQ.TypeResult || iq.type == IQ.TypeError;
		}
		
		public function collect(object:ISerializable):void
		{
			var iq:IQ = object as IQ;

			var responder:Function = XmppConnection(connection).getIQResponder(iq);
			if (responder != null)
			{
				responder(iq);
				connection.removeIQResponder(iq);
			}
		}
	}
}