package com.unikity.jabikity.manager
{
	import com.unikity.jabikity.protocol.core.Message;
	
	import flash.events.Event;
	
	public class ChatSessionEvent extends Event
	{
		/**
		 * Event dispatched when a chat session is created.
		 */
		public static const CHAT_SESSION_CREATED:String = "chatSessionCreated";
		
		/**
		 * Event dispatched when a chat session received a new message.
		 */
		public static const MESSAGE_RECEIVED:String = "messageReceived";	

		/**
		 * The chat that was created
		 */
		public var chatSession:ChatSession;
				
		/**
		 * The message was received
		 */
		public var message:Message;
		
		public function ChatSessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new ChatSessionEvent(type, bubbles, cancelable);
		}
	}
}