package com.unikity.jabikity.protocol.core.tls
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;

	public class TLSProceed extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "proceed";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-tls");
		
		public function TLSProceed()
		{
			super(ELEMENT, NS);
		}
	}
}