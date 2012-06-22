package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	 * XEP-0249: Direct MUC Invitations 
	 * http://www.xmpp.org/extensions/xep-0249.html
	 * 
	 * This specification defines a method for inviting a contact to a multi-user 
	 * chat room directly, instead of sending the invitation through the chat room.
	 */
	public class MUCDirectInvitation extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "x";
		public static const NS:Namespace = new Namespace("", "jabber:x:conference");

		/**
		 * Returns the address of the group chat room. GroupChat room addresses
		 * are in the form <tt>room@service</tt>, where <tt>service</tt> is
		 * the name of groupchat server, such as <tt>chat.example.com</tt>.
		 * 
		 * @return the address of the group chat room.
		 */
		public var roomJid:String;
		
		public function MUCDirectInvitation()
		{
			super(ELEMENT, NS);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@jid.length() > 0)
				roomJid = xml.@jid;
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (roomJid != null) 
				xml.@jid = roomJid;
			
			return xml;
		}
	}
}