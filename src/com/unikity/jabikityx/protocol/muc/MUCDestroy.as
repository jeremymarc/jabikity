package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	public class MUCDestroy extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "destroy";
		public static const NS:Namespace = MUCOwner.NS;
		
		/**
		 * Sets the JID of an alternate location since the current room is being destroyed.
		 */
		public var jid:String;
		
		/**
		 * Sets the reason for the room destruction.
		 */
		public var reason:String;
		
		public var password:String;
		
		public function MUCDestroy()
		{
			super(ELEMENT, NS);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@jid.length() > 0) jid = xml.@jid; 
			if (xml.reason.length() > 0) reason = xml.reason;
			if (xml.password.length() > 0) password = xml.password;
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (jid != null) xml.@jid = jid;
			if (reason != null) xml.reason = reason;
			if (password != null) xml.password = password;
			
			return xml;
		}
	}
}