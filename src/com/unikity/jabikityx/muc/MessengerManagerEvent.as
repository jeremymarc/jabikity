package com.unikity.jabikityx.muc
{
	import flash.events.Event;
	
	public class MessengerManagerEvent extends Event
	{
		
		/**
		 * Dispatched when a new private message received.
		 */
		public static const HEADLINE_RECEIVED:String = "messengerHeadlineReceived";		
		
		/**
		 * Dispatched when a new private message received.
		 */
		public static const PRIVATE_MESSAGE:String = "messengerPrivateMessage";	

/**
		 * Dispatched when a retrieving contact list
		 */
		public static const RECEIVING_CONTACT_LIST:String = "messengerReceivingContactList";		
		
		/**
		 * Dispatched when your user has joigned the room.
		 */
		public static const JOINED:String = "messengerJoined";

		/**
		 * Dispatched when your user has leaved the room.
		 */
		public static const LEAVED:String = "messengerLeaved";
		
		/**
		 * Dispatched when we are disconnected
		 */
		public static const DISCONNECTED:String = "messengerDisconnected";
		
		/**
		 * Dispatched when room informations has received.
		 */
		public static const INFORMATIONS_RECEIVED:String = "messengerInformationsReceived";
		
		
		/**
		 * Dispatched when your user has changed his nickname.
		 */
		public static const NICKNAME_CHANGED:String = "messengerNicknameChanged";
		
		/**
		 * Dispatched when your user has updated his status.
		 */
		public static const STATUS_UPDATED:String = "messengerStatusUpdated";
		
		
		/**
		 * Dispatched when an error occured.
		 */
		public static const ERROR:String = "messengerError";
		
		/**
		 * Dispatched when an error occured.
		 */
		public static const WRONG_LOGIN:String = "messengerWrongLogin";
		
		public var data:*;
		
		public function MessengerManagerEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}

		override public function clone():Event
		{
			return new MessengerManagerEvent(type, bubbles, cancelable);
		}

	}
}