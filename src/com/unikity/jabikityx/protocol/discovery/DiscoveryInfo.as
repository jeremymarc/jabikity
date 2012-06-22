package com.unikity.jabikityx.protocol.discovery
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	public class DiscoveryInfo extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "query";
		public static const NS:Namespace = new Namespace("", "http://jabber.org/protocol/disco#info");
		
		public var features:Array;
		public var identities:Array;
		public var node:String;
		
		public function DiscoveryInfo(node:String=null)
		{
			super(ELEMENT, NS);
			
			features = new Array();
			identities = new Array();
			
			this.node = node;
		}
		
		/**
		 * Adds a new feature to the discovered information.
		 */
		public function addFeature(feature:Feature):void
		{
			features.push(feature);
		}
		
		/**
		 * Adds a new identity of the requested entity to the discovered information.
		 */
		public function addIdentity(identity:Identity):void
		{
			identities.push(identity);
		}
		
		public function resetIdentities():void
		{
			identities = new Array();
		}
		
		public function resetFeatures():void
		{
			features = new Array();
		}
		
		/**
		 * Returns true if the specified feature is part of the discovered information.
		 */
		public function containFeature(feature:String):Boolean
		{
			for each (var f:Feature in features)
			{
				if (feature == f.variable)
					return true;
			}
			
			return false;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			for each (var xmlFeature:XML in xml.ns::feature)
				addFeature(new Feature(xmlFeature.@['var']));				
			
			for each (var xmlIdentity:XML in xml.ns::identity)
			{
				var identity:Identity = new Identity();
				identity.deserialize(xmlIdentity);
				addIdentity(identity);
			}
		}
				
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
						
			if (node) xml.@node = node;
			
			for each (var identity:Identity in identities)
				xml.appendChild(identity.serialize());

			for each (var feature:Feature in features)
				xml.appendChild(feature.serialize());

			return xml;
		}
	}
}