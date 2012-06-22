package com.unikity.jabikityx.protocol.ping
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0199: XMPP Ping, http://xmpp.org/extensions/xep-0199.html
	 */
	public class Ping extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "ping";
		public static const NS:Namespace = new Namespace("urn:xmpp:ping");
		
		public function Ping()
		{
			super(ELEMENT, NS);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);	
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			return xml;
		}
	}
}