package com.unikity.jabikityx.protocol.muc
{
	/**
	 * The protocol documented by this schema is defined in
	 * XEP-0045: http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUCErrorCode
	{
		/**
		 * Inform user that a password is required.
		 */
		public static const RoomPassword:int = 401;
		
		/**
		 * Inform user that he or she is banned from the room.
		 */
		public static const RoomBanned:int = 403;
		
		/**
		 * Inform user that the room does not exist.
		 */
		public static const RoomNotExists:int = 404;
		
		/**
		 *  Inform user that room creation is restricted.
		 */
		public static const RoomCreationRestricted:int = 405;
		
		/**
		 * Inform user that the reserved roomnick must be used.
		 */
		public static const ReservedNick:int = 406;
		
		/**
		 * Inform user that he or she is not on the member list.
		 */
		public static const NotInMemberList:int = 407;
		
		/**
		 * Inform user that his or her desired room nickname is in use or registered by another user.
		 */
		public static const NickConflict:int = 409;
		
		/**
		 * Inform user that the maximum number of users has been reached.
		 */
		public static const RoomNoPlace:int = 503;
	}
}