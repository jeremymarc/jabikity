package com.unikity.jabikity.protocol.im
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	public class Session extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "session";
		public static const NS:Namespace = new Namespace("urn:ietf:params:xml:ns:xmpp-session");
		
		public function Session()
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