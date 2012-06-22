package com.unikity.jabikity.protocol.im
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	import com.unikity.jabikityx.protocol.vcard.VCard;
	
	public class Roster extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "query";
		public static const NS:Namespace = new Namespace("", "jabber:iq:roster");
			
		public var items:Array;
		public var node:String;
				
		public function Roster(type:String=null, jid:String=null)
		{
			//super(jid, type);
			super(ELEMENT, NS);
			items = new Array();
		}
		
		private function addItem(item:RosterItem):void
		{	
			items.push(item);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			//var query:XML = xml..NS::query[0];
			
			for each (var item:XML in xml..NS::item)
			{
				var rosteritem:RosterItem = new RosterItem();
				rosteritem.deserialize(item);
				addItem(rosteritem);
			}
			
			super.deserialize(object);
		}
	
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			var query:XML = <{ELEMENT}/>;
			query.setNamespace(NS);
			
			if (node) query.@node = node;
			
			for each (var item:RosterItem in items)
				query.appendChild(item.serialize());

			xml.appendChild(query);
		
			return xml;
		}
	}
}