package com.unikity.jabikityx.muc
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.core.Message;
	import com.unikity.jabikityx.protocol.muc.MUCDirectInvitation;
	import com.unikity.jabikityx.protocol.muc.MUCUser;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
     * An InvitationManager monitors a given connection to detect room invitations. Every
     * time the InvitationsMonitor detects a new invitation it will fire the invitation listeners.
     */
	public class RoomInvitationManager implements IEventDispatcher, ICollector
	{
		protected var eventDispatcher:IEventDispatcher;		
		protected var connection:XmppConnection;
		
		/**
         * Creates a new InvitationsMonitor that will monitor invitations received
         * on a given connection.
         */
		public function RoomInvitationManager(connection:XmppConnection)
		{
			eventDispatcher = new EventDispatcher(this);
			
			this.connection = connection;
           	connection.registerCollector(this);
		}
		
		public function onRegister():void
		{
			trace("Collector for room invitation registered.");
		}
		
		public function onUnregister():void
		{
			trace("Collector for room invitation unregistered.");
		}
		
		public function release():void
		{
			// If the packet collector is registered, unregister them
			if (connection.hasCollector(this))
				connection.unregisterCollector(this);
		}
		
		/**
		 * Informs the sender of an invitation that the invitee declines the invitation. The rejection
		 * will be sent to the room which in turn will forward the rejection to the inviter.
		 * 
		 * @param conn the connection to use for sending the rejection.
		 * @param room the room that sent the original invitation.
		 * @param inviter the inviter of the declined invitation.
		 * @param reason the reason why the invitee is declining the invitation.
		 */
		public static function declineInvitation(connection:XmppConnection, room:String, inviter:String, reason:String):void
		{
			var message:Message = new Message(room);
			
			var mucUser:MUCUser = new MUCUser();
			mucUser.childType = MUCUser.TypeDecline;
			mucUser.host = inviter;
			mucUser.reason = reason;
			
			// Add the MUCUser packet that includes the rejection
			message.addChunk(mucUser);
			
			connection.send(message);
		}
		
		public function filter(object:ISerializable):Boolean
		{
			//  Listens for all messages that include a MUCUser extension with invitation child
			if (object is Message)
			{
				var message:Message = object as Message;
				
				if (message.type != Message.TypeError)
				{
					// Get the MUCUser extension
					var mucUser:MUCUser = message.getChunk(MUCUser) as MUCUser;
				
					// Check if the MUCUser extension includes an invitation
					if (mucUser != null && mucUser.childType == MUCUser.TypeInvite)
						return true;

					// Check for MUC direct invitation extension
					if (message.hasChunk(MUCDirectInvitation))
						return true;
				}
			}
			
			return false;
		}
		
		public function collect(object:ISerializable):void
		{
			var message:Message = object as Message;
			
			var roomInvitation:RoomInvitation = new RoomInvitation();
			
			var mucUser:MUCUser = message.getChunk(MUCUser) as MUCUser;
			if (mucUser != null)
			{
				roomInvitation.sender = mucUser.host;
				roomInvitation.room = message.from;
				roomInvitation.reason = mucUser.reason;
				roomInvitation.password = mucUser.password;
				roomInvitation.message = message;
				
				dispatchEvent(new RoomInvitationEvent(RoomInvitationEvent.ROOM_INVITATION_RECEIVED, roomInvitation));
			}
			else
			{
				var mucDirectInvitation:MUCDirectInvitation = message.getChunk(MUCDirectInvitation) as MUCDirectInvitation;
				if (mucDirectInvitation != null)
				{
					roomInvitation.sender = message.from;
					roomInvitation.room = mucDirectInvitation.roomJid;
					roomInvitation.message = message;
					
					dispatchEvent(new RoomInvitationEvent(RoomInvitationEvent.DIRECTROOM_INVITATION_RECEIVED, roomInvitation));
				}
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