package com.unikity.jabikity.protocol.core
{	
	public class Presence extends Stanza
	{
		public static const ELEMENT:String = "presence";

		/**
    	 * The entity is connected to the network.
    	 */
    	public static const TypeAvailable:String = "available";
    	
    	/**
    	 * Signals that the entity is no longer available for communication.
    	 */
    	public static const TypeUnavailable:String = "unavailable";
    	
    	/**
    	 * A request for an entity's current presence; SHOULD be generated only by a server on behalf of a user.
    	 */
    	public static const TypeProbe:String = "probe";
    	
    	/**
    	 * The sender wishes to subscribe to the recipient's presence.
    	 */
    	public static const TypeSubscribe:String = "subscribe";
    	
    	/**
    	 * The sender is unsubscribing from another entity's presence.
    	 */
    	public static const TypeUnsubscribe:String = "unsubscribe";
    	
    	/**
    	 * The sender has allowed the recipient to receive their presence.
    	 */
    	public static const TypeSubscribed:String = "subscribed";
    	
    	/**
    	 * The subscription request has been denied or a previously-granted subscription has been cancelled.
    	 */
    	public static const TypeUnsubscribed:String = "unsubscribed";
    	
    	/**
    	 * An error has occurred regarding processing or delivery of a previously-sent presence stanza.
    	 */
    	public static const TypeError:String = "error";
    	
    	public static const ModeAvailable:String = null;

    	/**
    	 * The entity or resource is actively interested in chatting.
    	 */
    	public static const ModeChat:String = "chat";
   
    	/**
    	 * The entity or resource is temporarily away.
    	 */
    	public static const ModeAway:String = "away";
    	
    	/**
    	 * The entity or resource is busy (dnd = "Do Not Disturb").
    	 */
    	public static const ModeDnd:String = "dnd";
    	
    	/**
    	 * The entity or resource is away for an extended period (xa = "eXtended Away"). For example, 
    	 * status may be "will be back from vacation in a week."
    	 */
    	public static const ModeXa:String = "xa";
    	
    	/**
    	 * The current presence of the user specified in this element.
    	 */
    	public var mode:String;
    	
    	/**
    	 * The status is a string with human readable text that further
    	 * elaborates on the 'show' status that the users presence
    	 * currently indicated. For example, if the current status is SHOW_AWAY,
    	 * the status may be 'Back in an hour after a meeting...'.
    	 */    	 
    	public var status:String;
    	
    	/**
    	 * The priority of this resources presence information. For example,
    	 * you may be logged in as two resources (same user) and want to make
    	 * this client's presence priority higher than other clients so that it
    	 * appears as this in clients who have subscribed to your presence.
    	 */
    	public var priority:int = -1;
    	
    	public function Presence(type:String=null)
        {
        	super(ELEMENT);
        	
        	this.type = type;
        }
        
        override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.status.length() > 0) status = xml.status;
			if (xml.show.length() > 0) mode = xml.show;
			if (xml.priority.length() > 0) priority = xml.priority;
		}

		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (mode != null) xml.show = mode; 
			if (status != null) xml.status = status;
			if (priority >= 0) xml.priority = priority;
			
			return xml;
		}
	}
}