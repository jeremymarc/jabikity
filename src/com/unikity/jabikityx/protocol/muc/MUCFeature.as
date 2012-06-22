package com.unikity.jabikityx.protocol.muc
{
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0045: http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUCFeature
	{
		// Public room in Multi-User Chat (MUC)
		public static const Public:String = "muc_public";

		// Hidden room in Multi-User Chat (MUC)
		public static const Hidden:String = "muc_hidden";
		
		// Moderated room in Multi-User Chat (MUC)
		public static const Moderated:String = "muc_moderated";
		
		// Unmoderated room in Multi-User Chat (MUC)
		public static const Unmoderated:String = "muc_unmoderated";
		
		// Non-anonymous room in Multi-User Chat (MUC)
		public static const NonAnonymous:String = "muc_nonanonymous";
		
		// Semi-anonymous room in Multi-User Chat (MUC)
		public static const SemiAnonymous:String = "muc_semianonymous";
		
		// Unsecured room in Multi-User Chat (MUC)
		public static const Unsecured:String = "muc_unsecured";
		
		// Password-protected room in Multi-User Chat (MUC)
		public static const PasswordProtected:String = "muc_passwordprotected";
		
		// Temporary room in Multi-User Chat (MUC)
		public static const Tempory:String = "muc_temporary";
		
		// Persistent room in Multi-User Chat (MUC)
		public static const Persistent:String = "muc_persistent";
		
		// Open room in Multi-User Chat (MUC)
		public static const Open:String = "muc_open";
		
		// Members-only room in Multi-User Chat (MUC)
		public static const MembersOnly:String = "muc_membersonly";
		
		// List of MUC rooms (each as a separate item)
		public static const Rooms:String = "muc_rooms";
		
		// Support for the muc#register FORM_TYPE
		public static const RegisterForm:String = "http://jabber.org/protocol/muc#register";
		
		// Support for the muc#roomconfig FORM_TYPE
		public static const RoomConfigForm:String = "http://jabber.org/protocol/muc#roomconfig";
		
		// Support for the muc#roominfo FORM_TYPE
		public static const RoomInfoForm:String = "http://jabber.org/protocol/muc#roominfo";
	}
}