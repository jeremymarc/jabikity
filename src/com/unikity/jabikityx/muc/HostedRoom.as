package com.unikity.jabikityx.muc
{
	import com.unikity.jabikity.protocol.core.JID;
	import com.unikity.jabikityx.protocol.discovery.DiscoItem;
	
	/**
	 * Hosted rooms by a chat service may be discovered if they are configured to appear in the room
	 * directory . The information that may be discovered is the XMPP address of the room and the room
	 * name. The address of the room may be used for obtaining more detailed information.
	 */
	public class HostedRoom
	{
		/**
		 * Returns the XMPP address of the hosted room by the chat service.
		 */
		public var jid:String;
		
		/**
		 * Returns the name of the room.
		 */
		public var name:String;
		
		public function HostedRoom(item:DiscoItem)
		{
			jid = item.jid;
			name = item.name;
		}
	}
}