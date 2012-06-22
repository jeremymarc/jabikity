package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	 * Extension that serves for kicking users, granting and revoking voice, banning users, 
	 * modifying the ban list, granting and revoking membership and granting and revoking 
	 * moderator privileges. All these operations are scoped by the 
	 * 'http://jabber.org/protocol/muc#admin' namespace.
	 */
	public class MUCAdmin extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "query";
		public static const NS:Namespace = new Namespace("", "http://jabber.org/protocol/muc#admin");
		
		public var items:Array;
		
		public function MUCAdmin()
		{
			super(ELEMENT, NS);
			
			items = new Array();
		}
		
		public function addItem(item:MUCAdminItem):void
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
			
			for each (var child:XML in xml.item)
			{
				var item:MUCAdminItem = new MUCAdminItem();
				item.deserialize(child);
				addItem(item);
			}
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			for each (var item:MUCAdminItem in this.items)
				xml.appendChild(item.serialize());

			return xml;
		}
	}
}