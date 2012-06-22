package com.unikity.jabikity.protocol.core.tls
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;

	public class TLSFailure extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "failure";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-tls");
		
		public function TLSFailure()
		{
			super(ELEMENT, NS);
		}
	}
}