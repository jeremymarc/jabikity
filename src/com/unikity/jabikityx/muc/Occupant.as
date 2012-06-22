package com.unikity.jabikityx.muc
{
	import com.unikity.jabikity.protocol.*;
	import com.unikity.jabikity.protocol.core.*;
	import com.unikity.jabikityx.protocol.muc.*;
	
	/**
	 * Represents the information about an occupant in a given room. The information will always have
	 * the affiliation and role of the occupant in the room. The full JID and nickname are optional.
	 */
	public class Occupant
	{
		public var jid:String;
		public var fullJid:String;
		
		public var affiliation:String;
		public var role:String;
		
		public var status:String;
		public var show:String;
		
		public var pendingNickname:String;
				
		public function Occupant(presence:Presence)
		{
			jid = presence.from;
			status = presence.status;
			show = presence.mode;
			
			var mucUser:MUCUser = presence.getChunk(MUCUser) as MUCUser;
			if (mucUser != null)
			{
				if (mucUser.items != null && mucUser.items[0] != null)
				{
					var mucUserItem:MUCUserItem = mucUser.items[0] as MUCUserItem;					
					if (mucUserItem != null)
					{
						// If is not an semi-anonymous room, set the real occupant jid
			    		if (mucUserItem.jid != null)
			    			fullJid = mucUserItem.jid;
			    				
			    		if (mucUserItem.nick != null)
			    			pendingNickname = mucUserItem.nick;
			    		
			    		// Role is tempory privileges set for a room session
			    		role = mucUserItem.role;
			    			
			    		// Affiliation is persistant privileges set by any room owner/admin
			    		affiliation = mucUserItem.affiliation;
			 		}
				}
			}
		}
		
		public function equals(obj:Object):Boolean
		{
			if (!(obj is Occupant))
				return false;
		
			if (obj == this)
				return true;
				
			var occupant:Occupant = obj as Occupant;
			
			return jid == occupant.jid;
		}
	}
}