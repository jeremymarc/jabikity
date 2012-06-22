package com.unikity.jabikityx.protocol.muc
{
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0045: http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUCAffiliation
	{
		// The member affiliation provides a way for a room owner or admin to specify a "whitelist" of users who are allowed to enter a members-only room.
		public static const Owner:String = "owner";
		
		public static const Admin:String = "admin";
		
		// The member affiliation also provides a way for users to effectively register with an open room and thus be lastingly associated with that room in 
		// some way (one result may be that the user's nickname is reserved in the room).
		public static const Member:String = "member";
		
		// An outcast is a user who has been banned from a room and who is not allowed to enter the room.
		public static const Outcast:String = "outcast";
		
		// The "None" affiliation is the absence of an affiliation.
		public static const None:String = "none";
	}
}