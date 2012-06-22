package com.unikity.jabikityx.muc
{
	import com.unikity.jabikity.protocol.core.JID;
	
	/**
	 * Represents an affiliation of a user to a given room. The affiliate's information will always have
	 * the bare jid of the real user and its affiliation. If the affiliate is an occupant of the room
	 * then we will also have information about the role and nickname of the user in the room.
	 */
	public class Affiliate
	{
		/**
		 * Returns the bare JID of the affiliated user. This information will always be available.
		 */
		public var jid:String;
		
		/**
		 * Returns the affiliation of the afffiliated user. Possible affiliations are: "owner", "admin",
		 * "member", "outcast". This information will always be available.
		 */
		public var affiliation:String;
		
		/**
		 * Returns the current role of the affiliated user if the user is currently in the room.
		 * If the user is not present in the room then the answer will be null.
		 */
    	public var role:String;
    	
    	/**
    	 * Returns the current nickname of the affiliated user if the user is currently in the room.
    	 * If the user is not present in the room then the answer will be null.
    	 */
    	public var nick:String;
		
		public function Affiliate()
		{
		}
	}
}