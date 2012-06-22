package com.unikity.jabikityx.protocol.discovery
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	public class DiscoItem extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "item";
		public static const NS:Namespace = DiscoveryItems.NS;
		
		public static const ActionUpdate:String = "update";
		public static const ActionRemove:String = "remove";
		
		public var jid:String;
		public var name:String;
		public var action:String;
		public var node:String;
		
		public function DiscoItem(jid:String=null, name:String=null, action:String=null, node:String=null)
		{
			super(ELEMENT, NS);
			
			this.jid = jid;
			this.name = name;
			this.action = action;
			this.node = node;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@action.length() > 0) this.action = xml.@action;
			if (xml.@jid.length() > 0) this.jid = xml.@jid;
			if (xml.@name.length() > 0) this.name = xml.@name;			
			if (xml.@node.length() > 0) this.node = xml.@node;			
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;

			if (action) xml.@action = action;
			if (jid) xml.@jid = jid;
			if (name) xml.@name = name;			
			if (node) xml.@node = node;

			return xml;
		}
	}
}