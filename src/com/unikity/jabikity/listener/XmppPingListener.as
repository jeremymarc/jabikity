package com.unikity.jabikity.listener
{
	import com.unikity.jabikity.*;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikityx.protocol.ping.Ping;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;

	public class XmppPingListener implements ICollector
	{
		public static const COLLECTOR_ID:String = "XmppPingListener";
		
		protected var connection:XmppConnection;
				
		public function XmppPingListener(connection:XmppConnection)
		{
			this.connection = connection;
		}
				
		public function onRegister():void
		{
			trace(COLLECTOR_ID + " registered.");
		}
		
		public function onUnregister():void
		{
			trace(COLLECTOR_ID + " unregistered.");
		}
		
		public function filter(object:ISerializable):Boolean
		{
			if (!(object is IQ))
				return false;

			var iq:IQ = object as IQ;
			
			return iq.type == IQ.TypeGet && iq.hasChunk(Ping);
		}
		
		public function collect(object:ISerializable):void
		{
			var iq:IQ = object as IQ;
			
			var response:IQ = new IQ(iq.from, IQ.TypeResult);
			response.id = iq.id;

			connection.send(response);
		}
	}
}