package com.unikity.jabikity.manager
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.core.Message;
	import com.unikity.jabikity.utils.RandomUtil;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;
	
	import flash.errors.IllegalOperationError;
	import flash.events.*;

	/**
	 * The chat manager keeps track of references to all current chats. It will not hold any references
	 * in memory on its own so it is neccesary to keep a reference to the chat object itself.
	 */
	public class ChatSessionManager implements IEventDispatcher, ICollector
	{
		/**
		 * A prefix helps to make sure that ID's are unique across mutliple instances.
		 */
		private static var prefix:String = RandomUtil.string(5);
		
		/**
		 * Keeps track of the current increment, which is appended to the prefix to
		 * forum a unique ID.
		 */
		private static var id:int = 0;
		
		/**
		 * Returns the next unique id. Each id made up of a short alphanumeric
		 * prefix along with a unique numeric value.
		 */
		private static function get nextId():String {
			return prefix + id++;
		}

		protected var eventDispatcher:IEventDispatcher;
		protected var connection:XmppConnection;
		
		/**
		 * Maps thread ID to chat session.
		 */
		private var threadChatSession:Array;
		
		/**
		 * Maps jids to chat session.
		 */
		private var jidChatSession:Array;
		
		public function ChatSessionManager(connection:XmppConnection)
		{
			eventDispatcher = new EventDispatcher(this);
			
			this.connection = connection;
           	connection.registerCollector(this);
           	
           	threadChatSession = new Array();
           	jidChatSession = new Array();
		}
		
		public function onRegister():void
		{
			trace("Collector for chat session registered.");
		}
		
		public function onUnregister():void
		{
			trace("Collector for chat session unregistered.");
		}
		
		public function createChatSession(userJid:String, createdLocally:Boolean, threadId:String=null):ChatSession
		{
			return _createChatSession(userJid, createdLocally, threadId);
		}
		
		public function removeChatSession(chatSession:ChatSession):void
		{
			if (chatSession.participant != null)
				delete jidChatSession[chatSession.participant];
				
			if (chatSession.threadId != null)
				delete threadChatSession[chatSession.threadId];
		}
		
		public function sendMessage(message:Message):void
		{
			connection.send(message);
		}
		
		public function filter(object:ISerializable):Boolean
		{
			if (!(object is Message))
				return false;
				
			var message:Message = object as Message;
			
			return message.type != Message.TypeGroupChat && message.type != Message.TypeHeadline;
		}
		
		public function collect(object:ISerializable):void
		{
			var message:Message = object as Message;
			
			var chatSession:ChatSession;
			
			if (message.threadId == null)
			{
				chatSession = getChatSession(message.from);
			}
			else
			{
				chatSession = getChatSessionByThreadId(message.threadId);
				if (chatSession == null)
					chatSession = getChatSession(message.from); // Try to locate the chat based on the sender of the message
			}
			
			 if (chatSession == null && message.type == Message.TypeChat)
				chatSession = creationChatSessionFromMessage(message);
			
			if (chatSession != null)	
				chatSession.deliverMessage(message);
		}
		
		private function _createChatSession(userJid:String, createdLocally:Boolean, threadId:String):ChatSession
		{
			if (threadId == null)
				threadId = nextId;
				
			var chatSession:ChatSession = threadChatSession[threadId];
			if (chatSession != null)
				throw new IllegalOperationError("ThreadId is already used.");
				
			chatSession = new ChatSession(this, userJid,createdLocally, threadId);
			
			jidChatSession[userJid] = chatSession;
			threadChatSession[threadId] = chatSession;
			
			var event:ChatSessionEvent = new ChatSessionEvent(ChatSessionEvent.CHAT_SESSION_CREATED);
			event.chatSession = chatSession;
			dispatchEvent(event);
			
			return chatSession;
		}
		
		private function creationChatSessionFromMessage(message:Message):ChatSession
		{
			var threadId:String = message.threadId;
			if (threadId == null)
				threadId = nextId;
				
			var userJid:String = message.from;
			
			return _createChatSession(userJid, false, threadId);
		}
		
		private function getChatSession(userJid:String):ChatSession
		{
			return jidChatSession[userJid] as ChatSession;
		}
		
		private function getChatSessionByThreadId(threadId:String):ChatSession
		{
			return threadChatSession[threadId] as ChatSession;
		}
		
		/**
		 * Event dispatcher implementation
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
    	
    	public function dispatchEvent(event:Event):Boolean
    	{
    		return eventDispatcher.dispatchEvent(event);
    	}
    	
    	public function hasEventListener(type:String):Boolean
    	{
    		return eventDispatcher.hasEventListener(type);
    	}
    	
    	public function willTrigger(type:String):Boolean
    	{
    		return eventDispatcher.willTrigger(type);
    	}
	}
}