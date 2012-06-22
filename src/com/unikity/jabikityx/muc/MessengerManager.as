package com.unikity.jabikityx.muc
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikity.protocol.core.Message;
	import com.unikity.jabikity.protocol.core.Presence;
	import com.unikity.jabikity.protocol.im.Roster;
	import com.unikity.jabikity.protocol.im.RosterItem;
	import com.unikity.jabikityx.protocol.form.DataForm;
	import com.unikity.jabikityx.protocol.form.FormField;
	import com.unikity.jabikityx.protocol.register.Register;
	import com.unikity.jabikityx.protocol.vcard.VCard;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
     * An InvitationManager monitors a given connection to detect room invitations. Every
     * time the InvitationsMonitor detects a new invitation it will fire the invitation listeners.
     */
	public class MessengerManager implements IEventDispatcher, ICollector
	{
		protected var eventDispatcher:IEventDispatcher;		
		protected var connection:XmppConnection;
		
		/**
         * Creates a new MessengerMonitor that will monitor messenger message received
         * on a given connection.
         */
		public function MessengerManager(connection:XmppConnection, user:String = null, pass:String = null)
		{
			eventDispatcher = new EventDispatcher(this);
			
			this.connection = connection;
           	connection.registerCollector(this);
           	
           	if (user != null && pass != null)
         	  	login(user, pass);
         	else {
         		var iq:IQ = new IQ(null, IQ.TypeGet);
				var roster:Roster = new Roster();
				iq.addChunk(roster);
			
				connection.send(iq);
         	}
         		
		}
		
		public function login(user:String, pass:String):void
		{
			var iq:IQ = new IQ("msn.unikity.fr", IQ.TypeSet);
           	var register:Register = new Register();
           	
           	var data:DataForm = new DataForm("submit");
           	var username:FormField = new FormField("username", null, null, null);
           	username.values = [user];
           	data.addField(username);
           	var password:FormField = new FormField("password", null, null, null);
           	password.values = [pass];
           	data.addField(password);
           	
           	register.addChunk(data);
           	iq.addChunk(register);
           	
           	connection.send(iq);
		}
		
		public function logout():void
		{
			var presence:Presence = new Presence(Presence.TypeUnavailable);
			presence.to = "msn.unikity.fr";
			
			connection.send(presence);
		}
		
		public function onRegister():void
		{
			trace("Collector for messenger registered.");
		}
		
		public function onUnregister():void
		{
			trace("Collector for messenger unregistered.");
		}
		
		public function release():void
		{
			// If the packet collector is registered, unregister them
			if (connection.hasCollector(this))
				connection.unregisterCollector(this);
		}
		

		public function filter(object:ISerializable):Boolean
		{
			//  Listens for all messages that include a MUCUser extension with invitation child
			if (object is IQ)
			{
				var iq:IQ = object as IQ;
				
				if (iq.type!= IQ.TypeError)
				{
					if (iq.type == IQ.TypeSet || iq.type == IQ.TypeResult)
					{
						var roster:Roster = iq.getChunk(Roster) as Roster;
						return roster != null;
					}
				}
				else
				{
					return true;
				}
			}
			
			if (object is Message)
			{
				var message:Message = object as Message;	
				return (message.type == Message.TypeHeadline  || message.type == Message.TypeError) && message.from.search("msn.unikity.fr") > 0;
			}
			
			if (object is Presence)
			{
				var presence:Presence = object as Presence;
				return ((presence.from.search("msn.unikity.fr") > 0) || presence.from == "msn.unikity.fr");
			}
			
			return false;
		}
		
		
		
		public function collect(object:ISerializable):void
		{
			if (object is IQ)
			{
				var iq:IQ = object as IQ;
				
				if (iq.type!= IQ.TypeError)
				{ 
					if (iq.type == IQ.TypeSet || iq.type == IQ.TypeResult)
					{
						var roster:Roster = iq.getChunk(Roster) as Roster;
						if (roster != null)
						{
							var items:Array = roster.items as Array;
							dispatchEvent(new MessengerManagerEvent(MessengerManagerEvent.RECEIVING_CONTACT_LIST, items));
						}
					}
					/*else if (iq.type == IQ.TypeResult)
					{
						var vcard:VCard = iq.getChunk(VCard) as VCard;
						if (vcard != null) {
							var event:MessengerManagerEvent = new MessengerManagerEvent(MessengerManagerEvent.INFORMATIONS_RECEIVED);
							event.data = iq;
							dispatchEvent(event);
						}
					}*/
				}
				
			}
			
			if (object is Message)
			{
				var message:Message = object as Message;
				if (message.type == Message.TypeError)
				{
					dispatchEvent(new MessengerManagerEvent(MessengerManagerEvent.WRONG_LOGIN, message.body));
				}
				else if (message.type == Message.TypeHeadline)
				{
					dispatchEvent(new MessengerManagerEvent(MessengerManagerEvent.HEADLINE_RECEIVED, message.body));
				}
			}
			
			if (object is Presence)
			{
				var presence:Presence = object as Presence;
				if (presence != null)
				{
					if (presence.type == Presence.TypeUnavailable) {
						if (presence.from == "msn.unikity.fr") {
							var event:MessengerManagerEvent = new MessengerManagerEvent(MessengerManagerEvent.DISCONNECTED);
							event.data = presence;
							dispatchEvent(event);
						} else {
							var event:MessengerManagerEvent = new MessengerManagerEvent(MessengerManagerEvent.LEAVED);
							event.data = presence;
							dispatchEvent(event);
						}
					}
					else {
						var event:MessengerManagerEvent = new MessengerManagerEvent(MessengerManagerEvent.JOINED);
						event.data = presence;
						dispatchEvent(event);
						
						//getUserInformations(presence.from);
					}
				}
			}
		}
		
		private function getUserInformations(to:String):void
		{
			var iq:IQ = new IQ(to, IQ.TypeGet);
			var vcard:VCard = new VCard();
			iq.addChunk(vcard);
			
			connection.send(iq);
		}
		
		public function setUserInformations(status:String, personalMessage:String):void
		{
			var presence:Presence = new Presence(Presence.TypeAvailable);
			if (status != null) 
				presence.mode = status;
			
			if (personalMessage != null)
				presence.status = personalMessage;
				
			//var vcard:VCard = new VCard();
			//vcard.nickname = "Jeremyyy";
			//presence.addChunk(vcard);
			
			connection.send(presence);
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