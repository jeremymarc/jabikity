package com.unikity.jabikityx.muc
{
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikity.utils.DateUtil;
	import com.unikity.jabikityx.protocol.discovery.DiscoveryInfo;
	import com.unikity.jabikityx.protocol.form.DataForm;
	import com.unikity.jabikityx.protocol.form.FormField;
	import com.unikity.jabikityx.protocol.muc.MUCFeature;
	import com.unikity.jabikityx.protocol.muc.MUCRoomInfo;
	
	/**
	 * Represents the room information that was discovered using Service Discovery. It's possible to
	 * obtain information about a room before joining the room but only for rooms that are public (i.e.
	 * rooms that may be discovered).
	 */
	public class RoomInformation
	{
		/**
		 * JID of the room. The node of the JID is commonly used as the ID of the room or name.
		 */
		public var jid:String;
		
		/**
		 * Name of the room
		 */
		public var name:String;
		
		/**
		 * Description of the room.
		 */
		public var description:String;
		
		/**
		 * Last known subject of the room.
		 */
		public var subject:String;
		
		/**
		 * Current number of occupants in the room.
		 */
		public var occupantsCount:int = -1;
	
		/**
		 * Creation date of the room
		 */
		public var creationDate:Date;

		public var ldapGroup:String;
		
		/**
		 * Lang of the room
		 */
		public var lang:String;
		
		public var contact:String;
		
		public var logs:String;
		
		/**
		 * A room is considered members-only if an invitation is required in order to enter the room.
		 * Any user that is not a member of the room won't be able to join the room unless the user
		 * decides to register with the room (thus becoming a member).
		 */
		public var membersOnly:Boolean;
		
		/**
		  * Moderated rooms enable only participants to speak. Users that join the room and aren't
		  * participants can't speak (they are just visitors).
		  */		
		public var moderated:Boolean;
		
		/**
		 * Every presence packet can include the JID of every occupant unless the owner deactives this
		 * configuration.
		 */
		public var nonAnonymous:Boolean;
		
		/**
		 * Indicates if users must supply a password to join the room.
		 */
		public var passwordProtected:Boolean;
		
		/**
		 * Persistent rooms are saved to the database to make sure that rooms configurations can be
		 * restored in case the server goes down.
		 */
		public var persistent:Boolean;
		
		/**
		 * Additionnals informations
		 */
		public var extended:Array;
		
		public function RoomInformation(iq:IQ)
		{
			extended = new Array();
			
			jid = iq.from;
			
			// Get the information based on the discovered features
			var discoInfo:DiscoveryInfo = iq.getChunk(DiscoveryInfo) as DiscoveryInfo;
			if (discoInfo != null)
			{
				membersOnly = discoInfo.containFeature(MUCFeature.MembersOnly);
				moderated = discoInfo.containFeature(MUCFeature.Moderated);
				nonAnonymous = discoInfo.containFeature(MUCFeature.NonAnonymous);
				passwordProtected = discoInfo.containFeature(MUCFeature.PasswordProtected);
				persistent = discoInfo.containFeature(MUCFeature.Persistent);
			}

			// Get the information based on the discovered extended information
			var form:DataForm = discoInfo.getChunk(DataForm) as DataForm;
			if (form != null)
			{
				for each (var field:FormField in form.fields)
				{
					switch (field.name)
					{
						case "FORM_TYPE":
							break;
						
						case MUCRoomInfo.Name:
							name = field.value;
							break;
							
						case MUCRoomInfo.Description:
							description = field.value;
							break;
							
						case MUCRoomInfo.Subject:
							subject = field.value;
							break;
						
						case MUCRoomInfo.Occupants:
							occupantsCount = field.value;
							break;
							
						case MUCRoomInfo.LdapGroup:
							ldapGroup = field.value;
							break;
							
						case MUCRoomInfo.Lang:
							lang = field.value;
							break;
							
						case MUCRoomInfo.Logs:
							logs = field.value;
							break;
							
						case MUCRoomInfo.CreationDate:
							creationDate = DateUtil.toISO8601Date(field.value);	
							break;
						
						case MUCRoomInfo.ContactJid:
							contact = field.value;
							break;
							
						default:
							extended[field.name] = field.value;
							break;
					}
				}
			}
		}
	}
}