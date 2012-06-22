package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.*;
	
	public class MUC extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "x";
		public static const NS:Namespace = new Namespace("", "http://jabber.org/protocol/muc");
		
		/**
		 * Returns the password to use when the room requires a password.
		 */
		public var password:String;
		
		/**
		 * Returns the history that manages the amount of discussion history provided on
		 * entering a room.
		 */
		public var history:MUCHistory;

		public function MUC()
		{
			super(ELEMENT, NS);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.password.length() > 0) 
				password = xml.password;
				
			if (xml.history.length() > 0)
			{
				history = new MUCHistory();
				history.deserialize(xml.history);
			}
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
									
			if (password != null) 
				xml.password = password;
				
			if (history != null)
				xml.appendChild(history.serialize());
			
			return xml;
		}
	}
}