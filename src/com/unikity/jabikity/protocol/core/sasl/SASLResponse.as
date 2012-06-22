package com.unikity.jabikity.protocol.core.sasl
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	//<response xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>
	//dXNlcm5hbWU9InNvbWVub2RlIixyZWFsbT0ic29tZXJlYWxtIixub25jZT0i
	//T0E2TUc5dEVRR20yaGgiLGNub25jZT0iT0E2TUhYaDZWcVRyUmsiLG5jPTAw
	//MDAwMDAxLHFvcD1hdXRoLGRpZ2VzdC11cmk9InhtcHAvZXhhbXBsZS5jb20i
	//LHJlc3BvbnNlPWQzODhkYWQ5MGQ0YmJkNzYwYTE1MjMyMWYyMTQzYWY3LGNo
	//YXJzZXQ9dXRmLTgK
	//</response>
	public class SASLResponse extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "response";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-sasl");
		
		public var content:String;

		public function SASLResponse(content:String=null)
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