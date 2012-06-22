package com.unikity.jabikity.protocol.core.sasl
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
		
	public class SASLAbort extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "abort";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-sasl");
		
		public function SASLAbort()
		{
			super(ELEMENT, NS);	
		}
	}
}