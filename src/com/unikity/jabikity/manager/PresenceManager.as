package com.unikity.jabikity.manager
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.core.*;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;
	
	import flash.events.*;

	/**
	 * Helper class for managing presence and subscriptions
	 */
	public class PresenceManager implements IEventDispatcher, ICollector
	{
		public static const COLLECTOR_ID:String = "PresenceManager";
		
		protected var eventDispatcher:IEventDispatcher;
		protected var connection:XmppConnection;
		
		public function PresenceManager(connection:XmppConnection)
		{
			eventDispatcher = new EventDispatcher(this);
			
			this.connection = connection;
			connection.registerCollector(this);
		}
		
		public function unregister():void
		{
			connection.unregisterCollector(this);
		}
		
		public function onRegister():void
		{
			trace("PresenceManager collector registered.");
		}
		
		public function onUnregister():void
		{
			trace("PresenceManager collector unregistered.");
		}
		
		/**
		 * Presence generic helper function
		 */
		public function sendPresence(to:String, type:String, status:String=null, mode:String=null, chunks:Array=null, priority:int=-1):void
		{
			var presence:Presence = new Presence(type);
			
			presence.to = to;
			presence.status = status;
			presence.mode = mode;
			presence.priority = priority;
			
			for each (var chunk:IXmppChunk in chunks)
				presence.addChunk(chunk);
			
			connection.send(presence);
		}
		
		public function sendRawPresence(presence:Presence):void
		{
			connection.send(presence);
		}
		
		/**
		 * Subscribe to a contact
		 */
		public function subscribe(to:String, message:String=null):void
		{
			sendPresence(to, Presence.TypeSubscribe, message);
		}
		
		/**
		 * Unsubscribe from a contact
		 */
		public function unsubscribe(to:String, message:String=null):void
		{
			sendPresence(to, Presence.TypeUnsubscribe, message);
		}
		
		/**
		 * Approving a subscription request
		 */
		public function approveSubscriptionRequest(to:String):void
		{
			sendPresence(to, Presence.TypeSubscribed);
		}
		
		/**
		 * Declining a presence subscription request
		 */
		public function declineSubscriptionRequest(to:String):void
		{
			sendPresence(to, Presence.TypeUnsubscribed);
		}
		
		public function filter(object:ISerializable):Boolean
		{
			return object is Presence;
		}
		
		public function collect(object:ISerializable):void
		{
			if (object is Presence)
				presenceHandler(Presence(object));
		}		
		
		private function presenceHandler(presence:Presence):void
		{
			switch (presence.type)
			{
				case Presence.TypeAvailable:
					dispatchEvent(new PresenceEvent(PresenceEvent.PRESENCE_AVAILABLE, presence));
					break;
				
				case Presence.TypeUnavailable:
					dispatchEvent(new PresenceEvent(PresenceEvent.PRESENCE_UNAVAILABLE, presence));
					break;
				
				case Presence.TypeProbe:
					dispatchEvent(new PresenceEvent(PresenceEvent.PRESENCE_PROBE, presence));
					break;
					
				case Presence.TypeSubscribe:
					dispatchEvent(new PresenceEvent(PresenceEvent.PRESENCE_SUBSCRIBE, presence));
					break;
					
				case Presence.TypeUnsubscribe:
					dispatchEvent(new PresenceEvent(PresenceEvent.PRESENCE_UNSUBSCRIBE, presence));
					break;
				
				case Presence.TypeSubscribed:
					dispatchEvent(new PresenceEvent(PresenceEvent.PRESENCE_SUBSCRIBED, presence));
					break;
				
				case Presence.TypeUnsubscribed:
					dispatchEvent(new PresenceEvent(PresenceEvent.PRESENCE_UNSUBSCRIBED, presence));
					break;
				
				default:
					dispatchEvent(new PresenceEvent(PresenceEvent.PRESENCE_AVAILABLE, presence));
					break;
			}
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