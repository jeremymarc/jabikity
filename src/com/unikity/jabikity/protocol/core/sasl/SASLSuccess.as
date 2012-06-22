package com.unikity.jabikity.protocol.core.sasl
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	// <success xmlns='urn:ietf:params:xml:ns:xmpp-sasl'/>
	public class SASLSuccess extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "success";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-sasl");
		
		public function SASLSuccess()
		{
			super(ELEMENT, NS);
		}
	}
}