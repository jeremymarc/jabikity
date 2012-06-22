package com.unikity.jabikityx.protocol.privatestorage
{
	import com.unikity.jabikity.protocol.*;
	import com.unikity.jabikity.protocol.core.*;
	
	/**
	 * XEP-0049: Private XML Storage: http://www.xmpp.org/extensions/xep-0049.html
	 */
	public class PrivateStorage extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "query";
		public static const NS:Namespace = new Namespace("", "jabber:iq:private");
		
		public var xml:XML;
		
		public function PrivateStorage()
		{
			super(ELEMENT, NS);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			var firstchild:XML = xml.*[0] as XML;
			
			this.xml = firstchild;
		}

		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			if (this.xml) xml.appendChild(this.xml);

			return xml;	
		}
	}
}