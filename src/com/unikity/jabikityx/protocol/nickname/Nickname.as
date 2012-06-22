package com.unikity.jabikityx.protocol.nickname
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0172: User Nickname, http://xmpp.org/extensions/xep-0172.html
	 * 
	 * This specification defines a protocol for communicating user nicknames, 
	 * either in XMPP presence subscription requests or in XMPP messages.
	 */
	public class Nickname extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "nick";
		public static const NS:Namespace = new Namespace("http://jabber.org/protocol/nick");
		
		public var nickname:String;

		public function Nickname(nickname:String="")
		{
			super(ELEMENT, NS);
			
			this.nickname = nickname;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			nickname = xml.valueOf();
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			xml.setChildren(nickname);
		
			return xml;
		}
	}
}