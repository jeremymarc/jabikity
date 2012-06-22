package com.unikity.jabikityx.protocol.muc
{
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0045: http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUCRole
	{
		// A moderator is the most powerful occupant within the context of the room, and can to some extent manage other occupants' roles in the room.
		public static const Moderator:String = "moderator";
			
		// A participant has fewer privileges than a moderator, although he or she always has the right to speak.
		public static const Participant:String = "participant";
		
		// A visitor is a more restricted role within the context of a moderated room, since visitors are not allowed to send messages to all occupants.
		public static const Visitor:String = "visitor";
		
		// No right
		public static const None:String = "none";
	}
}