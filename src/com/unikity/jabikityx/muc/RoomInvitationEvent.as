package com.unikity.jabikityx.muc
{
	import flash.events.Event;
	
	public class RoomInvitationEvent extends Event
	{
		/**
		 * Event dispatched anytime an invitation to join a MUC room is received.
		 */
		public static const ROOM_INVITATION_RECEIVED:String = "roomInvitationReceived";	
		
		/**
		 * Event dispatched anytime an direct invitation to join a MUC room is received.
		 * 
		 * Look: XEP-0249: Direct MUC Invitations, http://www.xmpp.org/extensions/xep-0249.html
		 */
		public static const DIRECTROOM_INVITATION_RECEIVED:String = "directRoomInvitationReceived";
		
		public var invitation:RoomInvitation;
		
		public function RoomInvitationEvent(type:String, invitation:RoomInvitation, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.invitation = invitation;
		}

		override public function clone():Event
		{
			return new RoomInvitationEvent(type, invitation, bubbles, cancelable);
		}
	}
}