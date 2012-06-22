package com.unikity.jabikity.listener
{
	import com.unikity.jabikity.*;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikityx.protocol.discovery.DiscoveryInfo;
	import com.unikity.jabikityx.protocol.discovery.Feature;
	import com.unikity.jabikityx.protocol.discovery.Identity;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;

	public class ClientCapabilitiesListener implements ICollector
	{
		public static const COLLECTOR_ID:String = "ClientCapabilitiesListener";
		
		protected var connection:XmppConnection;
				
		public function ClientCapabilitiesListener(connection:XmppConnection)
		{
			this.connection = connection;
		}
				
		public function onRegister():void
		{
			trace("ClientCapabilitiesListener registered.");
		}
		
		public function onUnregister():void
		{
			trace("ClientCapabilitiesListener unregistered.");
		}
		
		public function filter(object:ISerializable):Boolean
		{
			if (!(object is IQ))
				return false;
				
			var iq:IQ = object as IQ;
			
			return iq.type == IQ.TypeGet && iq.hasChunk(DiscoveryInfo);
		}
		
		public function collect(object:ISerializable):void
		{
			var iq:IQ = object as IQ;
			
			var response:IQ = new IQ(iq.from, IQ.TypeResult);
			response.id = iq.id;
					
			var discoInfo:DiscoveryInfo = new DiscoveryInfo();
			discoInfo.addIdentity(new Identity("client", "web", "jabikity"));
			
			// TODO: Send client extensions supports		
			//for each (var ns:Namespace in XepNS.supportedXepList)
			//	discoInfo.addFeature(new Feature(ns.uri));
					
			response.addChunk(discoInfo);
				
			connection.send(response);
		}
	}
}