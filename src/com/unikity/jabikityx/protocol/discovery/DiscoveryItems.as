package com.unikity.jabikityx.protocol.discovery
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	public class DiscoveryItems extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "query";
		public static const NS:Namespace = new Namespace("", "http://jabber.org/protocol/disco#items");
		
		public var node:String;
		public var items:Array;
				
		public function DiscoveryItems(node:String=null)
		{
			super(ELEMENT, NS);
			
			this.node = node;
			items = new Array();
		}
		
		public function addItem(item:DiscoItem):void
		{
			items.push(item);
		}
		
		public function resetItems():void
		{
			items = new Array();
		}
			
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@node.length() > 0) node = xml.@node;
			
			for each (var xmlItem:XML in xml.ns::item)
			{
				var item:DiscoItem = new DiscoItem();
				item.deserialize(xmlItem);
				addItem(item);
			}
		}
				
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (node) xml.@node = node;
			
			for each (var item:DiscoItem in items)
				xml.appendChild(item.serialize());
		
			return xml;
		}
	}
}