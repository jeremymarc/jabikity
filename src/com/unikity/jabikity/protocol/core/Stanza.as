package com.unikity.jabikity.protocol.core
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	import com.unikity.jabikity.protocol.core.errors.StanzaError;
	import com.unikity.jabikity.protocol.core.errors.XmppError;
	
	public class Stanza extends XmppChunk implements IXmppChunk
	{	
		public static const XML_NAMESPACE:Namespace = new Namespace("xml", "http://www.w3.org/XML/1998/namespace");
		
		public var id:String;
		public var from:String;
		public var to:String;
		public var type:String;    
		public var lang:String;
		public var error:XmppError;
		
		public function Stanza(tag:String, ns:Namespace=null)
		{
			super(tag, ns);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			xml.@id.length() > 0 ? id = xml.@id : id = null;
			
			if (xml.@from.length() > 0) this.from = xml.@from;
			if (xml.@to.length() > 0) this.to = xml.@to;
			if (xml.@type.length() > 0) this.type = xml.@type;
			
			if (xml.namespace("xml"))
			{
				var xmlNS:Namespace = xml.namespace("xml");
				lang = xml.@xmlNS::lang;
			}
			
			if (xml.error.length() > 0)
			{
				error = new StanzaError();
				error.deserialize(xml.error[0]);
			}		
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (id != null) xml.@id = id;
			if (from != null) xml.@from = from;
			if (to != null) xml.@to = to;			
			if (type != null) xml.@type = type;
			
			if (lang) 
			{
				var xmlNS:Namespace = XML_NAMESPACE;
				xml.addNamespace(xmlNS);
				xml.@xmlNS::lang = lang;
			}
			
			if (error)
				xml.appendChild(error.serialize());
			
			return xml;
		}
	}
}