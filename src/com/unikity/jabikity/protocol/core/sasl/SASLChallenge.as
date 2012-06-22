package com.unikity.jabikity.protocol.core.sasl
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	//<challenge xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>
	//cmVhbG09InNvbWVyZWFsbSIsbm9uY2U9Ik9BNk1HOXRFUUdtMmhoIixxb3A9ImF1dGgi
	//LGNoYXJzZXQ9dXRmLTgsYWxnb3JpdGhtPW1kNS1zZXNzCg==
	//</challenge>
	public class SASLChallenge extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "challenge";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-sasl");
		
		public var content:String;

		public function SASLChallenge(content:String=null)
		{
			super(ELEMENT, NS);	
			
			this.content = content;
		}

		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;			
			content = xml.valueOf().toString();
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (content) xml.appendChild(content);
			
			return xml;
		}
	}
}