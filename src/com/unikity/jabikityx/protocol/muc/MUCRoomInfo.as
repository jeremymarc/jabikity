package com.unikity.jabikityx.protocol.muc
{
	public class MUCRoomInfo
	{
		/**
		 * muc#roominfo FORM_TYPE
		 * Forms enabling the communication of extended service discovery information about a Multi-User Chat (MUC) room.
		 */
		public static const NS:String = "http://jabber.org/protocol/muc#roominfo";
		 
		public static const Name:String = "muc#roominfo_roomname";
		
		// Contact Addresses (normally, room owner or owners)
		public static const ContactJid:String = "muc#roominfo_contactjid";
		
		// Short Description of Room
		public static const Description:String = "muc#roominfo_description";
		
		// Current Subject or Discussion Topic in Room
		public static const Subject:String = "muc#roominfo_subject";
		
		// The room subject can be modified by participants
		public static const ChangeSubject:String = "muc#roominfo_subjectmod";
		
		// Natural Language for Room Discussions
		public static const Lang:String = "muc#roominfo_lang";
				
		// Current Number of Occupants in Room
		public static const Occupants:String = "muc#roominfo_occupants";
				
		// URL for Archived Discussion Logs
		public static const Logs:String = "muc#roominfo_logs";
		
		// Creation date of the room
		public static const CreationDate:String = "x-muc#roominfo_creationdate"; 
		
		// An associated LDAP group that defines room membership; this should be an LDAP Distinguished Name according to an
        // implementation-specific or deployment-specific definition of a group.
		public static const LdapGroup:String = "muc#roominfo_ldapgroup";

	}
}