package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	 * IQ packet that serves for granting and revoking ownership privileges, granting 
	 * and revoking administrative privileges and destroying a room. All these operations 
	 * are scoped by the 'http://jabber.org/protocol/muc#owner' namespace.
	 */
	public class MUCOwner extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "query";
		public static const NS:Namespace = new Namespace("", "http://jabber.org/protocol/muc#owner");
		
		/**
		 * item childs that holds information about affiliation, jids and nicks.
		 */
		[ArrayElementType("com.unikity.jabikityx.protocol.muc.MUCOwnerItem")]
		public var items:Array;
		
		/**
		 * Returns a request to the server to destroy a room. The sender of the request
		 * should be the room's owner. If the sender of the destroy request is not the room's owner
		 * then the server will answer a "Forbidden" error.
		 */
		public var destroy:MUCDestroy;
		
		public function MUCOwner()
		{
			super(ELEMENT, NS);
			
			items = new Array();
		}
		
		public function addItem(item:MUCOwnerItem):void
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
			
			if (xml.destroy.length() > 0)
			{
				destroy = new MUCDestroy();
				destroy.deserialize(xml.destroy);
			}
			
			for each (var xmlItem:XML in xml.ns::item)
			{
				var item:MUCOwnerItem = new MUCOwnerItem();
				item.deserialize(xmlItem);
				addItem(item);
			}
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
						
			if (destroy != null)
				xml.appendChild(destroy.serialize());
				
			for each (var item:MUCOwnerItem in this.items)
				xml.appendChild(item.serialize());
			
			return xml;
		}
	}
}