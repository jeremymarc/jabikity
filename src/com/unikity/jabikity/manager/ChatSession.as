package com.unikity.jabikity.manager
{
	import com.unikity.jabikity.protocol.core.Message;
	
	import flash.events.EventDispatcher;
	
	/**
	 * A chat session is a series of messages sent between two users. Each chat has a unique
	 * thread ID, which is used to track which messages are part of a particular
	 * conversation. Some messages are sent without a thread ID, and some clients
	 * don't send thread IDs at all. Therefore, if a message without a thread ID
	 * arrives it is routed to the most recently created Chat with the message sender.
	 */
	public class ChatSession extends EventDispatcher
	{
		/**
		 * Returns the chatManager the chat session will use.
		 */
		public var chatSessionManager:ChatSessionManager;
		
		/**
		 * Returns the thread id associated with this chat session, which corresponds to the
		 * <tt>thread</tt> field of XMPP messages. This method may return <tt>null</tt>
		 * if there is no thread ID is associated with this Chat session.
		 */
		public var threadId:String;
		
		/**
		 * Returns the name of the user the chat is with.
		 */
		public var participant:String;
		
		
		public var createdLocally:Boolean;
		
		
		public function ChatSession(chatSessionManager:ChatSessionManager, participant:String, createdLocally:Boolean, threadId:String=null)
		{
			this.chatSessionManager = chatSessionManager;
			this.participant = participant;
			this.createdLocally = createdLocally;
			this.threadId = threadId;
		}
		
		public function sendMessage(text:String):void
		{
			var message:Message = new Message(participant, Message.TypeChat, text, null, threadId);
			chatSessionManager.sendMessage(message);
		}
		
		public function sendRawMessage(message:Message):void
		{
			message.to = participant;
			message.type = Message.TypeChat;
			message.threadId = threadId;
			
			chatSessionManager.sendMessage(message);
		}
		
		public function deliverMessage(message:Message):void
		{
			var event:ChatSessionEvent = new ChatSessionEvent(ChatSessionEvent.MESSAGE_RECEIVED);
			event.chatSession = this;
			event.message = message;
			dispatchEvent(event);
		}
	}
}