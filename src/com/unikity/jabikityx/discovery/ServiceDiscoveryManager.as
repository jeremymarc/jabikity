package com.unikity.jabikityx.discovery
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikityx.protocol.discovery.DiscoveryInfo;
	import com.unikity.jabikityx.protocol.discovery.DiscoveryItems;
	
	/**
	 * XEP-0030: Service Discovery
	 * http://www.xmpp.org/extensions/xep-0030.html
	 */
	public class ServiceDiscoveryManager
	{
		protected var connection:XmppConnection;
		
		public function ServiceDiscoveryManager(connection:XmppConnection)
		{
			this.connection = connection;
		}
		
		/**
		 * Retrieves a list of available service information from the server specified. On successful query,
		 * the callback specified will be called and passed a single parameter containing
		 * a reference to an <code>IQ</code> containing the query results.
		 */
		public function discoverInfos(entityId:String, responder:Function, node:String=null):void
		{
			var iq:IQ = new IQ(entityId, IQ.TypeGet);			
			var discoInfo:DiscoveryInfo = new DiscoveryInfo();
			discoInfo.node = node;
			iq.addChunk(discoInfo);
						
			connection.addIQResponder(iq, responder);
			connection.send(iq);
		}
		
		/**
		 * Retrieves a list of available services items from the server specified. Items include things such
		 * as available transports and user directories. On successful query, the callback specified in the will be 
		 * called and passed a single parameter containing the query results.
		 */
		public function discoverItems(entityId:String, responder:Function, node:String=null):void
		{
			var iq:IQ = new IQ(entityId, IQ.TypeGet);			
			var discoItems:DiscoveryItems = new DiscoveryItems();
			discoItems.node = node;			
			iq.addChunk(discoItems);
			
			connection.addIQResponder(iq, responder);
			connection.send(iq);
		}
	}
}