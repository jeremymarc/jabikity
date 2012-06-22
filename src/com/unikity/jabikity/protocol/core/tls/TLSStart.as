package com.unikity.jabikity.protocol.core.tls
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;

	public class TLSStart extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "starttls";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-tls");
		
		public var required:Boolean = false;
		
		public function TLSStart()
		{
			super(ELEMENT, NS);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.required.length() > 0)
				required = true;
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (required) 
				xml.appendChild(<required />);
			
			return xml;
		}
	}
}