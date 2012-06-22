package com.unikity.jabikityx.protocol.capabilities
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0115: http://www.xmpp.org/extensions/xep-0115.html
	 */
	public class Capabilities extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "c";
		public static const NS:Namespace = new Namespace("http://jabber.org/protocol/caps");
		
		public var ext:String;
		public var hash:String
		public var version:String;
		public var node:String;
				
		public function Capabilities(hash:String=null, version:String=null, node:String=null, ext:String=null)
		{
			super(ELEMENT, NS);
			
			this.hash = hash;
			this.version = version;
			this.node = node;
			this.ext = ext;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@ext.length() > 0) ext = xml.@ext;
			if (xml.@hash.length() > 0) hash = xml.@hash;
			if (xml.@node.length() > 0) node = xml.@node;
			if (xml.@ver.length() > 0) version = xml.@ver;		
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (ext) xml.@ext = ext;
			if (hash) xml.@hash = hash;
			if (node) xml.@node = node;
			if (version) xml.@ver = version;
						
			return xml;
		}
	}
}