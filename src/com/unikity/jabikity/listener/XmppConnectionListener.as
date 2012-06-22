package com.unikity.jabikity.listener
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.XmppConnectionEvent;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikity.protocol.core.bind.Bind;
	import com.unikity.jabikity.protocol.core.stream.Stream;
	import com.unikity.jabikity.protocol.core.stream.StreamError;
	import com.unikity.jabikity.protocol.im.Session;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;

	public class XmppConnectionListener implements ICollector
	{
		public static const COLLECTOR_ID:String = "XmppConnectionListener";
		
		protected var connection:XmppConnection;
		
		public function XmppConnectionListener(connection:XmppConnection)
		{
			this.connection = connection;
		}
				
		public function onRegister():void
		{
			trace("XmppConnectionListener registered.");
		}
		
		public function onUnregister():void
		{
			trace("XmppConnectionListener unregistered.");
		}
		
		public function filter(object:ISerializable):Boolean
		{
			return object is Stream || object is StreamError || object is IQ;
		}
		
		public function collect(object:ISerializable):void
		{
			if (object is Stream)
			{
				if (!connection.ready)
				{
					var stream:Stream = object as Stream;
					connection.id = stream.id;
					connection.features = stream.features;
					
					var bindIq:IQ = new IQ(null, IQ.TypeSet);
					bindIq.addChunk(new Bind(connection.resource));
								
					connection.send(bindIq);
				}
				else // Server sent stream close element, disconnect
				{
					connection.disconnect();
				}
			}
			else if (object is StreamError)
			{
				var error:StreamError = object as StreamError;
				
				connection.dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.ERROR, error));
				connection.disconnect();
			}
			else if (object is IQ && !connection.ready) // Resource binding
			{
				var iq:IQ = object as IQ;
				
				if (iq.hasChunk(Bind))
				{
					var bind:Bind = iq.getChunk(Bind) as Bind;
					connection.jid = bind.jid;
					
					// Session iq
					var sessionIq:IQ = new IQ(null, IQ.TypeSet);
					sessionIq.addChunk(new Session());				
					connection.send(sessionIq);
				}
				else if (iq.hasChunk(Session))
				{
					connection.unregisterCollector(this);
					
					// Connection ready
					connection.ready = true;
					connection.dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.READY));
				}
			}
		}
	}
}