package com.unikity.jabikityx.protocol.muc
{
	public class MUCRoomConfig
	{
		public static const NS:String = "http://jabber.org/protocol/muc#roomconfig";
		
		// Whether to Allow Occupants to Change Subject
		public static const ChangeSubject:String = "muc#roomconfig_changesubject";
		
		// Whether to Allow Occupants to Invite Others
		public static const AllowInvites:String = "muc#roomconfig_allowinvites";
		
		// Whether to Enable Public Logging of Room Conversations
		public static const EnableLogging:String = "muc#roomconfig_enablelogging";
		
		// Roles and Affiliations that May Retrieve Member List
		public static const GetMemberList:String = "muc#roomconfig_getmemberlist";
		
		// Natural Language for Room Discussions
		public static const Lang:String = "muc#roomconfig_lang";
		
		// XMPP URI of Associated Publish-Subcribe Node
		public static const PubSub:String = "muc#roomconfig_pubsub";
		
		// Maximum Number of Room Occupants
		public static const MaxUsers:String = "muc#roomconfig_maxusers";
		
		// Whether an Make Room Members-Only
		public static const MembersOnly:String = "muc#roomconfig_membersonly";
		
		// Whether to Make Room Moderated
		public static const Moderated:String = "muc#roomconfig_moderatedroom";
		
		// Whether a Password is Required to Enter
		public static const PasswordProtected:String = "muc#roomconfig_passwordprotectedroom";
		
		// Whether to Make Room Persistent
		public static const Persistent:String = "muc#roomconfig_persistentroom";
		
		// Roles for which Presence is Broadcast
		public static const PresenceBroadcast:String = "muc#roomconfig_presencebroadcast";
		
		// Whether to Allow Public Searching for Room
		public static const Public:String = "muc#roomconfig_publicroom";
		
		// Full List of Room Admins
		public static const Admins:String = "muc#roomconfig_roomadmins";
		
		// Full List of Room Owners
		public static const Owners:String = "muc#roomconfig_roomowners";
		
		// Short Description of Room
		public static const Description:String = "muc#roomconfig_roomdesc";
		
		// Natural-Language Room Name
		public static const Name:String = "muc#roomconfig_roomname";
		
		// The Room Password
		public static const Password:String = "muc#roomconfig_roomsecret";
		
		// Affiliations that May Discover Real JIDs of Occupants
		public static const Whois:String = "muc#roomconfig_whois";
		
		// can register a nick in the room 
		public static const ReservedNick:String = "x-muc#roomconfig_reservednick";
		
		// can change nick in the room
		public static const CanChangeNick:String = "x-muc#roomconfig_canchangenick";
		
		public static const Registration:String = "x-muc#roomconfig_registration";
	}
}