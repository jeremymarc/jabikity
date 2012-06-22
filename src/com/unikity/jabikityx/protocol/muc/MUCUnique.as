package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0045: http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUCUnique extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "unique";
		public static const NS:Namespace = new Namespace("", "http://jabber.org/protocol/muc#unique");
		
		public var value:String;
		
		public function MUCUnique(value:String=null)
		{
			super(ELEMENT, NS);
			
			this.value = value;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			value = xml.valueOf().toString();
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (value) xml.appendChild(value);

			return xml;
		}
	}
}