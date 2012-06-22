package com.unikity.jabikityx.muc
{
	import flash.events.Event;
	
	public class ConferenceRoomEvent extends Event
	{
		/**
		 * Dispatched when the room has changed its subject.
		 */
		public static const SUBJECT_UPDATED:String = "subjectUpdated";
		
		/**
		 * Dispatched when a new public message received.
		 */
		public static const PUBLIC_MESSAGE:String = "publicMessage";
		
		/**
		 * Dispatched when a new private message received.
		 */
		public static const PRIVATE_MESSAGE:String = "privateMessage";		
		
		/**
		 * Dispatched when your user has joigned the room.
		 */
		public static const JOINED:String = "joined";
		
		/**
		 * Dispatched when your user has leaved the room.
		 */
		public static const LEAVED:String = "leaved";
		
		/**
		 * Dispatched when the room created
		 */
		public static const CREATED:String = "created";
		
		/**
		 * Dispatched when room informations has received.
		 */
		public static const INFORMATIONS_RECEIVED:String = "informationsReceived";
		
		/**
		 * Dispatched when room configuration has received.
		 */
		public static const CONFIGURATION_RECEIVED:String = "configurationReceived";
		
		/**
		 * Dispatched when room configuration has updated.
		 */
		public static const CONFIGURATION_UPDATED:String = "configurationUpdated";
		
		/**
		 * Dispatched when your user has changed his nickname.
		 */
		public static const NICKNAME_CHANGED:String = "nicknameChanged";
		
		/**
		 * Dispatched when your user has updated his status.
		 */
		public static const STATUS_UPDATED:String = "statusUpdated";
		
		/**
		 * Dispatched when a moderator kicked your user from the room. This means that you are no longer
		 * participanting in the room.
		 */		
		public static const KICKED:String = "kicked";
		
		/**
		 * Dispatched when an administrator or owner banned your user from the room. This means that you 
		 * will no longer be able to join the room unless the ban has been removed.
		 */
		public static const BANNED:String = "banned";
		
		/**
		 * Dispatched when a moderator grants voice to your user. This means that you were a visitor in 
		 * the moderated room before and now you can participate in the room by sending messages to 
		 * all occupants.
		 */
		public static const VOICE_GRANTED:String = "voiceGranted";
		
		/**
		 * Dispatched when a moderator revokes voice from your user. This means that you were a 
		 * participant in the room able to speak and now you are a visitor that can't send
		 * messages to the room occupants.
		 */
		public static const VOICE_REVOKED:String = "voiceRevoked";
		
		/**
		 * Dispatched when an administrator grants your user membership to the room. This means that you 
		 * will be able to join the members-only room. 
		 */
		public static const MEMBERSHIP_GRANTED:String = "membershipGranted";
		
		/**
		 * Dispatched when an administrator revokes your user membership to the room. This means that you 
		 * will not be able to join the members-only room.
		 */
		public static const MEMBERSHIP_REVOKED:String = "membershipRevoked";
		
		/**
		 * Dispatched when an administrator grants moderator privileges to your user. This means that you 
		 * will be able to kick users, grant and revoke voice, invite other users, modify room's 
		 * subject plus all the partcipants privileges.
		 */
		public static const MODERATOR_GRANTED:String = "moderatorGranted";
		
		/**
		 * Dispatched when an administrator revokes moderator privileges from your user. This means that 
		 * you will no longer be able to kick users, grant and revoke voice, invite other users, 
		 * modify room's subject plus all the partcipants privileges.
		 */
		public static const MODERATOR_REVOKED:String = "moderatorRevoked";
		
		/**
		 * Dispatched when an owner grants administrator privileges to your user. This means that you 
		 * will be able to perform administrative functions such as banning users and edit moderator list.
		 */
		public static const ADMIN_GRANTED:String = "adminGranted";
		
		/**
		 * Called when an owner revokes administrator privileges from your user. This means that you 
		 * will no longer be able to perform administrative functions such as banning users and edit moderator list.
		 */
		public static const ADMIN_REVOKED:String = "adminRevoked";
		
		/**
		 * Dispatched when an owner grants to your user ownership on the room. This means that you 
		 * will be able to change defining room features as well as perform all administrative 
		 * functions.
		 */
		public static const OWNERSHIP_GRANTED:String = "ownerShipGranted";
		
		/**
		 * Dispatched when an owner revokes from your user ownership on the room. This means that you 
		 * will no longer be able to change defining room features as well as perform all 
		 * administrative functions.
		 */
		public static const OWNERSHIP_REVOKED:String = "ownerShipRevoked";	
		

		/**
		 * Dispatched when a new room occupant has joined the room. Note: Take in consideration that when
		 * you join a room you will receive the list of current occupants in the room. This message will
		 * be sent for each occupant.
		 */
		public static const OCCUPANT_JOINED:String = "occupantJoined";
		
		/**
		 * Dispatched when a room occupant has left the room on its own. This means that the occupant was
		 * neither kicked nor banned from the room.
		 */
		public static const OCCUPANT_LEAVED:String = "occupantLeaved";
		
		/**
		 * Dispatched when an occupant has changed his nickname.
		 */
		public static const OCCUPANT_NICKNAME_CHANGED:String = "occupantNicknameChanged";
		
		/**
		 * Dispatched when an occupant has updated his status.
		 */
		public static const OCCUPANT_STATUS_UPDATED:String = "occupantStatusUpdated";
		
		/**
		 * Dispatched when a room participant has been kicked from the room. This means that the kicked 
		 * participant is no longer participating in the room.
		 */		
		public static const OCCUPANT_KICKED:String = "occupantKicked";
		
		/**
		 * Dispatched when an administrator or owner banned a participant from the room. This means that 
		 * banned participant will no longer be able to join the room unless the ban has been removed.
		 */
		public static const OCCUPANT_BANNED:String = "occupantBanned";	
		
		/**
		 * Dispatched when a moderator grants voice to a visitor. This means that the visitor 
		 * can now participate in the moderated room sending messages to all occupants.
		 */
		public static const OCCUPANT_VOICE_GRANTED:String = "occupantVoiceGranted";
		
		/**
		 * Dispatched when a moderator revokes voice from a participant. This means that the participant 
		 * in the room was able to speak and now is a visitor that can't send messages to the room 
		 * occupants.
		 */
		public static const OCCUPANT_VOICE_REVOKED:String = "occupantVoiceRevoked";
		
		/**
		 * Dispatched when an administrator grants moderator privileges to a user. This means that the user 
		 * will be able to kick users, grant and revoke voice, invite other users, modify room's 
		 * subject plus all the partcipants privileges.
		 */
		public static const OCCUPANT_MODERATOR_GRANTED:String = "occupantModeratorGranted";
		
		/**
		 * Dispatched when an administrator revokes moderator privileges from a user. This means that the 
		 * user will no longer be able to kick users, grant and revoke voice, invite other users, 
		 * modify room's subject plus all the partcipants privileges.
		 */
		public static const OCCUPANT_MODERATOR_REVOKED:String = "occupantModeratorRevoked";
		
		/**
		 * Dispatched when an administrator grants a user membership to the room. This means that the user 
		 * will be able to join the members-only room.
		 */
		public static const OCCUPANT_MEMBERSHIP_GRANTED:String = "occupantMembershipGranted";
		
		/**
		 * Dispatched when an administrator revokes a user membership to the room. This means that the 
		 * user will not be able to join the members-only room.
		 */
		public static const OCCUPANT_MEMBERSHIP_REVOKED:String = "occupantMembershipRevoked";
		
		/**
		 * Dispatched when an owner grants administrator privileges to a user. This means that the user 
		 * will be able to perform administrative functions such as banning users and edit moderator list.
		 */
		public static const OCCUPANT_ADMIN_GRANTED:String = "occupantAdminGranted";
		
		/**
		 * Called when an owner revokes administrator privileges from a user. This means that the user 
		 * will no longer be able to perform administrative functions such as banning users and edit moderator list.
		 */
		public static const OCCUPANT_ADMIN_REVOKED:String = "occupantAdminRevoked";
		
		/**
		 * Dispatched when an owner grants a user ownership on the room. This means that the user
		 * will be able to change defining room features as well as perform all administrative functions.
		 */
		public static const OCCUPANT_OWNERSHIP_GRANTED:String = "occupantOwnerShipGranted";
		
		/**
		 * Dispatched when an owner revokes a user ownership on the room. This means that the user 
		 * will no longer be able to change defining room features as well as perform all administrative functions.
		 */
		public static const OCCUPANT_OWNERSHIP_REVOKED:String = "occupantOwnerShipRevoked";
		
		/**
		 * Dispatched when an error occured.
		 */
		public static const ERROR:String = "error";
		
		public var data:*;
		
		public function ConferenceRoomEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}

		override public function clone():Event
		{
			return new ConferenceRoomEvent(type, bubbles, cancelable);
		}
	}
}