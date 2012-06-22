package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
     * Item child that holds information about roles, affiliation, jids and nicks.
     */
	public class MUCAdminItem extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "item";
		public static const NS:Namespace = MUCAdmin.NS;
		
		/**
		 * Returns the <room@service/nick> by which an occupant is identified within the context 
         * of a room. If the room is non-anonymous, the JID will be included in the item. 
		 */
		public var jid:String;
		
		/**
		 * Returns the actor (JID of an occupant in the room) that was kicked or banned.
		 */
		public var actor:String;
		
		/**
		 * Returns the reason for the item child. The reason is optional and could be used to
         * explain the reason why a user (occupant) was kicked or banned.
         */
		public var reason:String;
		
		/**
		 * Returns the occupant's affiliation to the room. The affiliation is a semi-permanent 
         * association or connection with a room. The possible affiliations are "owner", "admin", 
         * "member", and "outcast" (naturally it is also possible to have no affiliation). An 
         * affiliation lasts across a user's visits to a room.
         */
		public var affiliation:String;
		
		/**
		 * Returns the temporary position or privilege level of an occupant within a room. The 
         * possible roles are "moderator", "participant", and "visitor" (it is also possible to 
         * have no defined role). A role lasts only for the duration of an occupant's visit to 
         * a room.
         */
		public var role:String;
		
		/**
		 * Returns the new nickname of an occupant that is changing his/her nickname. The new 
         * nickname is sent as part of the unavailable presence.
         */
		public var nick:String;

		public function MUCAdminItem()
		{
			super(ELEMENT, NS);
			
			this.affiliation = affiliation;
			this.role = role;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			// Attributes
			if (xml.@jid.length() > 0) this.jid = xml.@jid;			
			if (xml.@affiliation.length() > 0) this.affiliation = xml.@affiliation;
			if (xml.@role.length() > 0) this.role = xml.@role;
			if (xml.@nick.length() > 0) this.nick = xml.@nick;
			
			// Child nodes
			if (xml.actor.@jid.length() > 0) this.actor = xml.actor.@jid;
			if (xml.reason.length() > 0) this.reason = xml.reason;
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			// Attributes
			if (jid) xml.@jid = jid;
			if (affiliation) xml.@affiliation = affiliation;
			if (role) xml.@role = role;
			if (nick) xml.@nick = nick;
			
			// Child nodes
			if (actor) xml.actor.@jid = actor;
			if (reason) xml.reason = reason;
			
			return xml;
		}
	}
}