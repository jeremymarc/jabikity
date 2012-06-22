package com.unikity.jabikityx.protocol.muc
{
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0045: http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUCStatusCode
	{
		/**
		 * Unknown
		 */
		public static const Unknown:int = -1;
		
		/**
		 * Inform user that any occupant is allowed to see the user's full JID.
		 */
		public static const FullJidVisible:int = 100;
		
		/**
		 * Inform user that his or her affiliation changed while not in the room.
		 */
		public static const AffiliationChanged:int = 101;
		
		/**
		 * Inform occupants that room now shows unavailable members.
		 */
		public static const ShowUnavailableMembers:int = 102;
		
		/**
		 * Inform occupants that room now does not show unavailable members.
		 */
		public static const HideUnavailableMembers:int = 103;
		
		/**
		 * Inform occupants that some room configuration has changed.
		 */
		public static const ConfigurationChanged:int = 104;
		
		/**
		 * Inform user that presence refers to one of its own room occupants.
		 */
		public static const PresenceOwnOccupants:int = 110;
		
		/**
		 * Inform occupant that room UI should not allow cut-copy-and-paste operations.
		 */
		public static const RoomUiProhibitCopyPaste:int = 171;
		
		/**
		 * Inform occupant that room UI should allow cut-copy-and-paste operations.
		 */
		public static const RoomUiAllowCopyPaste:int = 172;
		
		/**
		 * Inform occupants that the room is now semi-anonymous.
		 */
		public static const RoomSemiAnonymous:int = 173;
		
		/**
		 * Inform occupants that the room is now fully-anonymous.
		 */
		public static const RoomFullyAnonymous:int = 174;
		
		/**
		 * Inform user that a new room has been created.
		 */
		public static const RoomCreated:int = 201;
		
		/**
		 * Inform user that service has assigned or modified occupant's roomnick.
		 */
		public static const ServiceModificationRoomNick:int = 210;
		
		/**
		 * Inform user that he or she has been banned from the room.
		 */
		public static const Banned:int = 301;
		
		/**
		 * Inform all occupants of new room nickname
		 */
		public static const NewNickname:int = 303;
		
		/**
		 * Inform user that he or she has been kicked from the room.
		 */
		public static const Kicked:int = 307;
		
		/**
		 * Inform user that he or she is being removed from the room because of an affiliation change.
		 */
		public static const AffiliationChange:int = 321;
		
		/**
		 * Inform user that he or she is being removed from the room because the room has been changed
		 * to members-only and the user is not a member
		 */
		public static const MembersOnly:int = 322;
		
		/**
		 * Inform user that he or she is being removed from the room because of a system shutdown.
		 */
		public static const SystemShutdown:int = 332;
		
	}
}