package com.unikity.jabikityx.protocol.delayeddelivery
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	import com.unikity.jabikity.utils.DateUtil;
	
	/**
	 * Delayed Delivery
	 * The protocol documented by this schema is defined in
	 * XEP-0091: http://www.xmpp.org/extensions/xep-0091.html
	 * 
	 * NOTE: This protocol has been deprecated in favor of the 
	 * Delayed Delivery protocol specified in XEP-0203: 
	 * http://www.xmpp.org/extensions/xep-0203.html
	 */
	public class Delayed extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "x";
		public static const NS:Namespace = new Namespace("", "jabber:x:delay");
		
		public var from:String;
		public var time:Date;
				
		public function Delayed(from:String=null, time:Date=null)
		{
			super(ELEMENT, NS);
			
			this.from = from;
			this.time = time;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@from.length() > 0) from = xml.@from;
			if (xml.@stamp.length() > 0) time = DateUtil.toISO8601Date(xml.@stamp);
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (from != null) xml.@from = from;
			if (time != null) xml.@stamp = DateUtil.toISO8601String(time);
			
			return xml;
		}
	}
}