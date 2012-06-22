package com.unikity.jabikity.protocol.core.bind
{
	import com.unikity.jabikity.protocol.*;
	import com.unikity.jabikity.protocol.core.*;

	public class Bind extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "bind";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-bind");
		
		public var jid:String;
		public var resource:String;
		
		public function Bind(resource:String=null, jid:String=null)
		{
			super(ELEMENT, NS);
			
			this.resource = resource;
			this.jid = jid;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.jid.length() > 0) jid = xml.jid;
			if (xml.resource.length() > 0) resource = xml.resource;
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (resource != null) xml.resource = resource;
			if (jid != null) xml.jid = jid;
						
			return xml;
		}
	}
}