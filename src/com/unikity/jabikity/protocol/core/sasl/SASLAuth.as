package com.unikity.jabikity.protocol.core.sasl
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	// <auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' mechanism='DIGEST-MD5'/>
	public class SASLAuth extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "auth";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-sasl");
		
		public var mechanism:String;
		public var content:String;

		public function SASLAuth(mechanism:String=null, content:String=null)
		{
			super(ELEMENT, NS);
			
			this.mechanism = mechanism;		
			this.content = content;
		}

		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
		
			if (xml.@mechanism.length() > 0) mechanism = xml.@mechanism;
			
			content = xml.valueOf().toString();
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (mechanism) xml.@mechanism = mechanism;
			if (content) xml.appendChild(content);

			return xml;
		}
	}
}