package com.unikity.jabikityx.muc
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikity.protocol.core.JID;
	import com.unikity.jabikity.protocol.core.Message;
	import com.unikity.jabikity.protocol.core.Presence;
	import com.unikity.jabikity.protocol.core.Stanza;
	import com.unikity.jabikityx.discovery.ServiceDiscoveryManager;
	import com.unikity.jabikityx.form.Form;
	import com.unikity.jabikityx.protocol.discovery.DiscoItem;
	import com.unikity.jabikityx.protocol.discovery.DiscoveryInfo;
	import com.unikity.jabikityx.protocol.discovery.DiscoveryItems;
	import com.unikity.jabikityx.protocol.form.DataForm;
	import com.unikity.jabikityx.protocol.muc.MUC;
	import com.unikity.jabikityx.protocol.muc.MUCAdmin;
	import com.unikity.jabikityx.protocol.muc.MUCAdminItem;
	import com.unikity.jabikityx.protocol.muc.MUCAffiliation;
	import com.unikity.jabikityx.protocol.muc.MUCDestroy;
	import com.unikity.jabikityx.protocol.muc.MUCDirectInvitation;
	import com.unikity.jabikityx.protocol.muc.MUCHistory;
	import com.unikity.jabikityx.protocol.muc.MUCOwner;
	import com.unikity.jabikityx.protocol.muc.MUCOwnerItem;
	import com.unikity.jabikityx.protocol.muc.MUCRole;
	import com.unikity.jabikityx.protocol.muc.MUCStatusCode;
	import com.unikity.jabikityx.protocol.muc.MUCUser;
	import com.unikity.jabikityx.protocol.muc.MUCUserItem;
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.serializer.ISerializable;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.rpc.IResponder;
	
	public class ConferenceRoom implements IEventDispatcher, ICollector
	{
		private static const discoNamespace:String = "http://jabber.org/protocol/muc";
		private static const discoNode:String = "http://jabber.org/protocol/muc#rooms";
		
		protected var eventDispatcher:IEventDispatcher;
				
		public var connection:XmppConnection;
		
		/**
		 * Returns the jid of the room this MultiUserChat object represents.
		 */
		public var roomJid:String;
		
		/**
		 * Returns true if this room joined
		 */
		public var joined:Boolean;
		
		/**
		 * Returns true if this room created
		 */
		public var created:Boolean;
		
		/**
		 * Returns the nickname that was used to join the room, or <tt>null</tt> if not
		 * currently joined.
		 */
		public var nickname:String;
		
		/**
		 * Returns a collection of <code>Occupant</code> that have the specified room role.
		 */
		public var occupants:Array;


		public function ConferenceRoom(connection:XmppConnection, roomJid:String)
		{
			eventDispatcher = new EventDispatcher(this);			
			occupants = new Array();
			
			this.connection = connection;
			this.roomJid = roomJid.toLowerCase();
			
			// Register the packet collector
           	connection.registerCollector(this);
		}
		
		public function release():void
		{
			// If the packet collector is registered, unregister them
			if (connection.hasCollector(this))
				connection.unregisterCollector(this);
				
			occupants = new Array();
			nickname = null;
			created = false;
			joined = false;
		}
		
		public function onRegister():void
		{
			trace("Collector for room \"" + roomJid + "\" registered.");
		}
		
		public function onUnregister():void
		{
			trace("Collector for room \"" + roomJid + "\" unregistered.");
		}
		
		/**
		 * Returns true if the specified user supports the Multi-User Chat protocol.
		 *
		 * @param connection the connection to use to perform the service discovery.
		 * @param user the user to check. A fully qualified xmpp ID, e.g. jdoe@example.com.
		 * @param responder called when the result received.
		 * 
		 * @return a boolean indicating whether the specified user supports the MUC protocol.
		 */
		 public static function isServiceEnabled(connection:XmppConnection, user:String, responder:IResponder):void
		 {
		 	var discoManager:ServiceDiscoveryManager = new ServiceDiscoveryManager(connection);
		 	
		 	discoManager.discoverInfos(user, 
				function(iq:IQ):void
				{
					if (iq.type == IQ.TypeResult && iq.hasChunk(DiscoveryInfo))
					{
						var discoInfo:DiscoveryInfo = iq.getChunk(DiscoveryInfo) as DiscoveryInfo;
						if (discoInfo != null)
						{
							var isServiceEnabled:Boolean = discoInfo.containFeature(discoNamespace);
							responder.result(isServiceEnabled);
						}
					}
					else
					{
						responder.fault(iq);
					}
				}
			);
		 }
		 
		 /**
		 * Returns an Array of HostedRooms where each HostedRoom has the XMPP address of the room
		 * and the room's name. Once discovered the rooms hosted by a chat service it is possible to
		 * discover more detailed room information or join the room.
		 * 
		 * @param connection the XMPP connection to use for discovering hosted rooms by the MUC service.
		 * @param serviceName the service that is hosting the rooms to discover.
		 * @param responder called when the result received.
		 * 
		 * @return an Array of HostedRooms.
		 */
		public static function getHostedRooms(connection:XmppConnection, serviceName:String, responder:IResponder):void
		{
			var discoManager:ServiceDiscoveryManager = new ServiceDiscoveryManager(connection);
			
			discoManager.discoverItems(serviceName, 
				function(iq:IQ):void
				{
					if (iq.type == IQ.TypeResult && iq.hasChunk(DiscoveryItems))
					{
						var discoItems:DiscoveryItems = iq.getChunk(DiscoveryItems) as DiscoveryItems;
						
						var hostedRooms:Array = new Array();
						
						for each (var discoItem:DiscoItem in discoItems.items)
						{
							var hostedRoom:HostedRoom = new HostedRoom(discoItem);
							hostedRooms.push(hostedRoom);
						}
						
						responder.result(hostedRooms);
					}
					else
					{
						responder.fault(iq);
					}
				}
			);
		}
						
		/**
		 * Returns the list of the rooms where the requested user has joined. The list will
		 * contain Strings where each String represents a room (e.g. room@muc.jabber.org).
		 * 
		 * @param connection the XMPP connection to use for discovering hosted rooms by the MUC service.
		 * @param user the user to check. A fully qualified xmpp ID, e.g. jdoe@example.com.
		 * @param responder called when the result received.
		 * 
		 * @return Array of joined rooms jid
		 */
		public static function getJoinedRooms(connection:XmppConnection, user:String, responder:IResponder):void
		{
			var discoManager:ServiceDiscoveryManager = new ServiceDiscoveryManager(connection);
			
			// Send the disco packet to the user
			discoManager.discoverItems(user, 
				function(iq:IQ):void
				{
					if (iq.type == IQ.TypeResult && iq.hasChunk(DiscoveryItems))
					{
						var discoItems:DiscoveryItems = iq.getChunk(DiscoveryItems) as DiscoveryItems;
						
						var joinedRooms:Array = new Array();
						
						for each (var discoItem:DiscoItem in discoItems.items)
							joinedRooms.push(discoItem.jid);
						
						responder.result(joinedRooms);
					}
					else
					{
						responder.fault(iq);
					}
				}
			, discoNode);
		}
		
		/**
		 * Returns the discovered information of a given room without actually having to join the room.
		 * The server will provide information only for rooms that are public.
		 * 
		 * @param connection the XMPP connection to use for discovering hosted rooms by the MUC service.
		 * @param roomJid the jid of the room in the form "roomName@service" of which we want to discover its information.
		 * @param responder called when the result received.
		 * 
		 * @return RoomInformation object
		 */
		public static function getRoomInformations(connection:XmppConnection, roomJid:String, responder:IResponder):void
		{
			var discoManager:ServiceDiscoveryManager = new ServiceDiscoveryManager(connection);
			
			discoManager.discoverInfos(roomJid, 
				function(iq:IQ):void
				{
					if (iq.type == IQ.TypeResult && iq.hasChunk(DiscoveryInfo))
					{
						var roomInfos:RoomInformation = new RoomInformation(iq);
						responder.result(roomInfos);
					}
					else
					{
						responder.fault(iq);
					}
				}
			);
		}
		
		/**
		 * Returns the discovered information of a given room without actually having to join the room.
		 * The server will provide information only for rooms that are public.
		 * 
		 * @param connection the XMPP connection to use for discovering hosted rooms by the MUC service.
		 * @param roomJid the jid of the room in the form "roomName@service" of which we want to discover its information.
		 * @param responder called when the result is ready.
		 * 
		 * @return RoomInformation object
		 */
		public function getInformations():void
		{
			var discoManager:ServiceDiscoveryManager = new ServiceDiscoveryManager(connection);
			
			discoManager.discoverInfos(roomJid, 
				function(iq:IQ):void
				{
					if (iq.type == IQ.TypeResult && iq.hasChunk(DiscoveryInfo))
					{
						var roomInfos:RoomInformation = new RoomInformation(iq);
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.INFORMATIONS_RECEIVED, roomInfos));
					}
					else
					{
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.ERROR, iq));
					}
				}
			);
		}
		
		/**
		 * Returns the room's configuration form that the room's owner can use or <tt>null</tt> if
		 * no configuration is possible. The configuration form allows to set the room's language,
		 * enable logging, specify room's type, etc..
		 */
		public function getConfigurationForm():void
		{
			var iq:IQ = new IQ(roomJid, IQ.TypeGet);
			
			var mucOwner:MUCOwner = new MUCOwner();
			iq.addChunk(mucOwner);
			
			// Request the configuration form to the server.
			connection.addIQResponder(iq, 
				function(iq:IQ):void
				{
					if (iq.type == IQ.TypeResult && iq.hasChunk(MUCOwner))
					{
						var mucOwner:MUCOwner = iq.getChunk(MUCOwner) as MUCOwner;
						if (mucOwner != null) 
						{
							var configDataForm:DataForm = mucOwner.getChunk(DataForm) as DataForm;
							if (configDataForm != null)
							{
								var configurationForm:Form = new Form(configDataForm);
								dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.CONFIGURATION_RECEIVED, configurationForm));
							}
						}
					}
					else
					{
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.ERROR, iq));
					}
				}
			);
						
			connection.send(iq);
		}
		
		/**
		 * Sends the completed configuration form to the server. The room will be configured
		 * with the new settings defined in the form. If the form is empty then the server
		 * will create an instant room (will use default configuration).
		 */
		public function sendConfigurationForm(configurationForm:Form):void
		{
			var iq:IQ = new IQ(roomJid, IQ.TypeSet);
			
			var mucOwner:MUCOwner = new MUCOwner();
			mucOwner.addChunk(configurationForm.getDataFormToSend());
			iq.addChunk(mucOwner);
			
			// Send the configuration form to the server.
			connection.addIQResponder(iq, 
				function(iq:IQ):void
				{
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.CONFIGURATION_UPDATED, new Form(configurationForm.getDataFormToSend())));
				}
			);
			
			connection.send(iq);
		}
		
		/**
		 * Creates the room according to some default configuration, assign the requesting user
		 * as the room owner, and add the owner to the room but not allow anyone else to enter
		 * the room (effectively "locking" the room). The requesting user will join the room
		 * under the specified nickname as soon as the room has been created.<p>
		 * 
		 * To create an "Instant Room", that means a room with some default configuration that is
		 * available for immediate access, the room's owner should send an empty form after creating
		 * the room. {@link #sendConfigurationForm(Form)}<p>
		 * 
		 * To create a "Reserved Room", that means a room manually configured by the room creator
		 * before anyone is allowed to enter, the room's owner should complete and send a form after
		 * creating the room. Once the completed configutation form is sent to the server, the server
		 * will unlock the room. {@link #sendConfigurationForm(Form)}
		 * 
		 * @param nickname the nickname to use.
		 * @mode mode
		 * @status status
		 * @param chunks chunks packets to includes in join presence packet.
		 */
		public function create(nickname:String, mode:String=null, status:String=null, chunks:Array=null):void
		{
			if (nickname == null || nickname == "")
            	throw new ArgumentError("Nickname must not be null or blank.");
            	
            if (joined)
            	throw new IllegalOperationError("Creation failed - user already joined the room.");
            
            this.nickname = nickname;
            
            // We create a room by sending a presence packet to room@service/nick
			// and signal support for MUC. The owner will be automatically logged into the room.
			var joinPresence:Presence = new Presence();
			joinPresence.to = roomJid + "/" + nickname;
			joinPresence.priority = 5;
            joinPresence.mode = mode;
            joinPresence.status = status;
			
			// Indicate the the client supports MUC
			var muc:MUC = new MUC();
			joinPresence.addChunk(muc);
			
			for each (var chunk:IXmppChunk in chunks)
	        	joinPresence.addChunk(chunk);
			
			connection.send(joinPresence);
		}
					
		/**
		 * Sends a request to the server to destroy the room. The sender of the request
		 * should be the room's owner. If the sender of the destroy request is not the room's owner
		 * then the server will answer a "Forbidden" error (403).
		 * 
		 * @param reason the reason for the room destruction.
		 * @param alternateJID the JID of an alternate location.
		 */
		public function destroy(reason:String, alternateJid:String, password:String=null):void
		{
			var iq:IQ = new IQ(roomJid, IQ.TypeSet);
			
			var mucDestroy:MUCDestroy = new MUCDestroy();
			mucDestroy.reason = reason;
			mucDestroy.jid = alternateJid;
			mucDestroy.password = password;
			
			var mucOwner:MUCOwner = new MUCOwner();
			mucOwner.destroy = mucDestroy;
			
			connection.send(iq);
		}
				
		/**
		 * Joins the chat room using the specified nickname. If already joined
		 * using another nickname, this method will first leave the room and then
		 * re-join using the new nickname. The default timeout of Smack for a reply
		 * from the group chat server that the join succeeded will be used. After
		 * joining the room, the room will decide the amount of history to send.
		 * 
		 * @param nickname the nickname to use.
		 * @param password the password to use for join the room
		 * @param mode
		 * @param status
		 * @param history enable history or not
		 * @param childs childs packets to includes in join presence packet
		 */
		public function join(nickname:String, password:String=null, mode:String=null, status:String=null, history:MUCHistory=null, chunks:Array=null):void
		{
			if (nickname == null || nickname == "")
            	throw new ArgumentError("Nickname must not be null or blank.");
            
            this.nickname = nickname;
            
            // If we've already joined the room, leave it before joining under a new nickname.
            if (joined)
            	leave();         
            	
            // We join a room by sending a presence packet where the "to" field is in the form "roomName@service/nickname"
            var joinPresence:Presence = new Presence();
            joinPresence.to = roomJid + "/" + nickname;
            joinPresence.priority = 5;
            joinPresence.mode = mode;
            joinPresence.status = status;
            
            // Indicate the the client supports MUC
            var muc:MUC = new MUC();
            if (password != null)
            	muc.password = password;
 
            if (history != null)
            	muc.history = history;
            
            joinPresence.addChunk(muc);
            
            for each (var chunk:IXmppChunk in chunks)
	        	joinPresence.addChunk(chunk);
            
            connection.send(joinPresence);
		}
		
		/**
		 * Leave the chat room.
		 */
		public function leave():void
		{
        	// Check that we already have joined the room before attempting to leave the room.
			if (!joined)
            	throw new IllegalOperationError("Must be logged into the room to leave the room.");
            	
            var leavePresence:Presence = new Presence();
            leavePresence.type = Presence.TypeUnavailable;
            leavePresence.to = roomJid + "/" + nickname;
            
			connection.send(leavePresence);
		}
		
		/**
		 * Changes the occupant's nickname to a new nickname within the room. Each room occupant
		 * will receive two presence packets. One of type "unavailable" for the old nickname and one
		 * indicating availability for the new nickname. The unavailable presence will contain the new
		 * nickname and an appropriate status code (namely 303) as extended presence information. The
		 * status code 303 indicates that the occupant is changing his/her nickname.
		 * 
		 * @param nickname the new nickname within the room.
		 */
		public function changeNickname(nickname:String, chunks:Array=null):void
		{
			if (nickname == null || nickname == "")
				throw new ArgumentError("Nickname must not be null or blank.");
				
			// Check that we already have joined the room before attempting to change the nickname.
			if (!joined)
            	throw new IllegalOperationError("Must be logged into the room to change nickname.");
            	
			// We change the nickname by sending a presence packet where the "to"
			// field is in the form "roomName@service/nickname"
			// We don't have to signal the MUC support again
			var joinPresence:Presence = new Presence();
			joinPresence.to = roomJid + "/" + nickname;
			
			for each (var chunk:IXmppChunk in chunks)
	        	joinPresence.addChunk(chunk);
			
			connection.send(joinPresence);
		}
		
		/**
		 * Changes the occupant's availability status within the room. The presence type
		 * will remain available but with a new status that describes the presence update and
		 * a new presence mode (e.g. Extended away).
		 * 
		 * @param status a text message describing the presence update.
		 * @param mode the mode type for the presence update.
		 */
		public function changeStatus(mode:String, status:String, chunks:Array=null):void
		{
			if (nickname == null || nickname == "")
				throw new ArgumentError("Nickname must not be null or blank.");
				
			// Check that we already have joined the room before attempting to change the nickname.
			if (!joined)
            	throw new IllegalOperationError("Must be logged into the room to change nickname.");
            	
			// We change the availability status by sending a presence packet to the room with the
			// new presence status and mode
			var joinPresence:Presence = new Presence();
			joinPresence.to = roomJid + "/" + nickname;
			joinPresence.mode = mode;
			joinPresence.status = status;
			
			for each (var chunk:IXmppChunk in chunks)
	        	joinPresence.addChunk(chunk);
			
			connection.send(joinPresence);
		}
		
		/**
		 * Sends a message to the chat room.
		 * 
		 * @param text the text of the message to send.
		 */
		public function sendPublicMessage(text:String, chunks:Array=null):void
		{
			var message:Message = new Message(roomJid, Message.TypeGroupChat, text);
			
			for each (var chunk:IXmppChunk in chunks)
	        	message.addChunk(chunk);
			
			sendMessage(message);
		}
		
		/**
		 * Send a private message to a room occupant.
		 * 
		 * The Chat's occupant address is the room's JID (i.e. roomName@service/nick). The server
		 * service will change the 'from' address to the sender's room JID and delivering the message
		 * to the intended recipient's full JID.
		 * 
		 * @param nickname nickname unique nickname.
		 * @param text the text of the message to send.
		 */
		public function sendPrivateMessage(nickname:String, text:String, chunks:Array=null):void
		{
			var message:Message = new Message(roomJid + "/" + nickname, Message.TypeNormal, text);
			
			for each (var chunk:IXmppChunk in chunks)
	        	message.addChunk(chunk);
			
			sendMessage(message);
		}
		
		public function sendMessage(message:Message):void
		{
			connection.send(message);
		}
		
		/**
		 * Changes the subject within the room. As a default, only users with a role of "moderator"
		 * are allowed to change the subject in a room. Although some rooms may be configured to
		 * allow a mere participant or even a visitor to change the subject.
		 * 
		 * @param subject the new room's subject to set.
		 */
		public function changeSubject(subject:String):void
		{
			var message:Message = new Message(roomJid, Message.TypeGroupChat);
			message.subject = subject;
			connection.send(message);
		}
		
		/**
		 * Invites another user to the room in which one is an occupant. The invitation
		 * will be sent to the room which in turn will forward the invitation to the invitee.
		 * 
		 * If the room is password-protected, the invitee will receive a password to use to join
		 * the room. If the room is members-only, the the invitee may be added to the member list.
		 * 
		 * @param user the user to invite to the room.(e.g. hecate@shakespeare.lit)
		 * @param reason the reason why the user is being invited.
		 * @param password the password used to join the room.
		 */
		public function invite(user:String, reason:String, password:String=null):void
		{
			var message:Message = new Message(roomJid);
			
			var mucUser:MUCUser = new MUCUser();
			mucUser.childType = MUCUser.TypeInvite;
			mucUser.invited = user;
			mucUser.reason = reason;
			mucUser.password = password;

			// Add the MUCUser packet that includes the invitation to the message
			message.addChunk(mucUser);
			
			connection.send(message);
		}
		
		/**
		 * Handle direct invitation
		 * http://www.xmpp.org/extensions/xep-0249.html
		 * 
		 * @param user the full user jid to invite to the room.(e.g. hecate@shakespeare.lit)
		 */
		public function directInvite(user:String):void
		{
			var message:Message = new Message(user);
			
			var directInvitation:MUCDirectInvitation = new MUCDirectInvitation();
			directInvitation.roomJid = roomJid;			
			message.addChunk(directInvitation);
			
			connection.send(message);
		}
		
		/**
		 * Kicks a visitor or participant from the room. The kicked occupant will receive a presence
		 * of type "unavailable" including a status code 307 and optionally along with the reason
		 * (if provided) and the bare JID of the user who initiated the kick. After the occupant
		 * was kicked from the room, the rest of the occupants will receive a presence of type
		 * "unavailable". The presence will include a status code 307 which means that the occupant
		 * was kicked from the room.
		 * 
		 * @param nickname the nickname of the participant or visitor to kick from the room (e.g. "john").
		 * @param reason the reason why the participant or visitor is being kicked from the room.
		 */
		public function kickParticipant(nickname:String, reason:String):void
		{
			changeRole(nickname, MUCRole.None, reason);
		}
		
		/**
		 * Bans a user from the room. An admin or owner of the room can ban users from a room. This
		 * means that the banned user will no longer be able to join the room unless the ban has been
		 * removed. If the banned user was present in the room then he/she will be removed from the
		 * room and notified that he/she was banned along with the reason (if provided) and the bare
		 * XMPP user ID of the user who initiated the ban.
		 * 
		 * @param jid the bare XMPP user ID of the user to ban (e.g. "user@host.org").
		 * @param reason the reason why the user was banned.
		 */
		public function banParticipant(nickname:String, reason:String=null):void
		{
			changeAffiliationByAdminNickname(nickname, MUCAffiliation.Outcast, reason);
		}
		
		/**
		 * Grants voice to a visitor in the room. In a moderated room, a moderator may want to manage
		 * who does and does not have "voice" in the room. To have voice means that a room occupant
		 * is able to send messages to the room occupants
		 * 
		 * @param nickname the nickname of the visitor to grant voice in the room (e.g. "john").
		 * @param reason the reason
		 */
		public function grantVoice(nickname:String, reason:String=null):void
		{
			changeRole(nickname, MUCRole.Participant, reason);
		}
		
		/**
		 * Revoke voice to a visitor in the room. In a moderated room, a moderator may want to manage
		 * who does and does not have "voice" in the room. To have voice means that a room occupant
		 * is able to send messages to the room occupants
		 * 
		 * @param nickname the nickname of the visitor to grant voice in the room (e.g. "john").
		 * @param reason the reason
		 */
		public function revokeVoice(nickname:String, reason:String=null):void
		{
			changeRole(nickname, MUCRole.Visitor, reason);
		}
		
		/**
		 * Grants moderator privileges to participants or visitors. Room administrators may grant
		 * moderator privileges. A moderator is allowed to kick users, grant and revoke voice, invite
		 * other users, modify room's subject plus all the partcipants privileges.
		 * 
		 * @param nicknames the nicknames of the occupants to grant moderator privileges.
		 * @param reason the reason
		 */
		public function grantModerator(nickname:String, reason:String=null):void
		{
			changeRole(nickname, MUCRole.Moderator, reason);
		}
		
		/**
		 * Revoke moderator privileges to participants or visitors. Room administrators may grant
		 * moderator privileges. A moderator is allowed to kick users, grant and revoke voice, invite
		 * other users, modify room's subject plus all the partcipants privileges.
		 * 
		 * @param nicknames the nicknames of the occupants to grant moderator privileges.
		 * @param reason the reason
		 */
		public function revokeModerator(nickname:String, reason:String=null):void
		{
			changeRole(nickname, MUCRole.Participant, reason);
		}
		
		/**
		 * Grants membership to a user. Only administrators are able to grant membership. A user
		 * that becomes a room member will be able to enter a room of type Members-Only (i.e. a room
		 * that a user cannot enter without being on the member list).
		 * 
		 * @param jid the XMPP user ID of the user to grant membership (e.g. "user@host.org").
		 * @param reason the reason.
		 */
		public function grantMembership(nickname:String, reason:String=null):void
		{
			changeAffiliationByAdminNickname(nickname, MUCAffiliation.Member, reason);
		}
		
		/**
		 * Revokes users' membership. Only administrators are able to revoke membership. A user
		 * that becomes a room member will be able to enter a room of type Members-Only (i.e. a room
		 * that a user cannot enter without being on the member list). If the user is in the room and
		 * the room is of type members-only then the user will be removed from the room.
		 * 
		 * @param jids the bare XMPP user IDs of the users to revoke membership.
		 * @param reason the reason
		 */
		public function revokeMembership(nickname:String, reason:String=null):void
		{
			changeAffiliationByAdminNickname(nickname, MUCAffiliation.None, reason);
		}
		
		/**
		 * Grants administrator privileges to another user. Room owners may grant administrator
		 * privileges to a member or unaffiliated user. An administrator is allowed to perform
		 * administrative functions such as banning users and edit moderator list.
		 * 
		 * @param jid the bare XMPP user ID of the user to grant administrator privileges (e.g. "user@host.org").
		 * @param reason the reason.
		 */
		public function grantAdmin(nickname:String, reason:String=null):void
		{
			changeAffiliationByOwnerNickname(nickname, MUCAffiliation.Admin, reason);
		}
		
		/**
		 * Revokes administrator privileges from users. The occupant that loses administrator
		 * privileges will become a member. Room owners may revoke administrator privileges from
		 * a member or unaffiliated user.
		 * 
		 * @param jids the bare XMPP user IDs of the user to revoke administrator privileges.
		 * @param reason the reason.
		 */
		public function revokeAdmin(nickname:String, reason:String=null):void
		{
			changeAffiliationByOwnerNickname(nickname, MUCAffiliation.Member, reason);
		}
		
		/**
		 * Revokes ownership privileges from other users. The occupant that loses ownership
		 * privileges will become an administrator. Room owners may revoke ownership privileges.
		 * Some room implementations will not allow to grant ownership privileges to other users.
		 * 
		 * @param jids the bare XMPP user IDs of the users to revoke ownership.
		 * @param reason the reason.
		 */
		public function grantOwnership(nickname:String, reason:String=null):void
		{
			changeAffiliationByOwnerNickname(nickname, MUCAffiliation.Owner, reason);
		}
		
		/**
		 * Revokes ownership privileges from another user. The occupant that loses ownership
		 * privileges will become an administrator. Room owners may revoke ownership privileges.
		 * Some room implementations will not allow to grant ownership privileges to other users.
		 * 
		 * @param jid the bare XMPP user ID of the user to revoke ownership (e.g. "user@host.org").
		 * @param reason the reason.
		 */
		public function revokeOwnership(nickname:String, reason:String=null):void
		{
			changeAffiliationByOwnerNickname(nickname, MUCAffiliation.Admin, reason);
		}
		
		public function changeAffiliationByOwner(jid:String, affiliation:String, reason:String):void
		{
			var iq:IQ = new IQ(roomJid, IQ.TypeSet);
			
			// Set the new affiliation.
			var mucOwnerItem:MUCOwnerItem = new MUCOwnerItem();
			mucOwnerItem.jid = jid;
			mucOwnerItem.affiliation = affiliation;
			mucOwnerItem.reason = reason;
			
			var mucOwner:MUCOwner = new MUCOwner();
			mucOwner.addItem(mucOwnerItem);
			
			iq.addChunk(mucOwner);
			
			connection.send(iq);
		}
		
		public function changeAffiliationByOwnerNickname(nickname:String, affiliation:String, reason:String):void
		{
			var iq:IQ = new IQ(roomJid, IQ.TypeSet);
			
			// Set the new affiliation.
			var mucOwnerItem:MUCOwnerItem = new MUCOwnerItem();
			mucOwnerItem.nick = nickname;
			mucOwnerItem.affiliation = affiliation;
			mucOwnerItem.reason = reason;
			
			var mucOwner:MUCOwner = new MUCOwner();
			mucOwner.addItem(mucOwnerItem);
			
			iq.addChunk(mucOwner);
			
			connection.send(iq);
		}
		
		public function changeAffiliationByAdmin(jid:String, affiliation:String, reason:String):void
		{
			var iq:IQ = new IQ(roomJid, IQ.TypeSet);
			
			// Set the new affiliation.
			var mucAdminItem:MUCAdminItem = new MUCAdminItem();
			mucAdminItem.jid = jid;
			mucAdminItem.affiliation = affiliation;
			mucAdminItem.reason = reason;
			
			var mucAdmin:MUCAdmin = new MUCAdmin();
			mucAdmin.addItem(mucAdminItem);
			
			iq.addChunk(mucAdmin);
			
			connection.send(iq);
		}
		
		public function changeAffiliationByAdminNickname(nickname:String, affiliation:String, reason:String):void
		{
			var iq:IQ = new IQ(roomJid, IQ.TypeSet);
			
			// Set the new affiliation.
			var mucAdminItem:MUCAdminItem = new MUCAdminItem();
			mucAdminItem.nick = nickname;
			mucAdminItem.affiliation = affiliation;
			mucAdminItem.reason = reason;
			
			var mucAdmin:MUCAdmin = new MUCAdmin();
			mucAdmin.addItem(mucAdminItem);
			
			iq.addChunk(mucAdmin);
			
			connection.send(iq);
		}		

		public function changeRole(nickname:String, role:String, reason:String):void
		{
			var iq:IQ = new IQ(roomJid, IQ.TypeSet);
			
			// Set the new role.
			var mucAdminItem:MUCAdminItem = new MUCAdminItem();
			mucAdminItem.role = role;
			mucAdminItem.nick = nickname;
			mucAdminItem.reason = reason;
			
			var mucAdmin:MUCAdmin = new MUCAdmin();
			mucAdmin.addItem(mucAdminItem);
			
			iq.addChunk(mucAdmin);

			connection.send(iq);
		}

		/**
		 * Determines if the <code>from</code> param is the
		 * same as the user's JID.
		 */
		private function isTheUser(from:String):Boolean
		{
			var myRoomJid:String = roomJid + "/" + nickname;
			return from == myRoomJid;
		}
		
		public function filter(object:ISerializable):Boolean
		{
			if (object is Stanza)
			{
				var stanza:Stanza = object as Stanza;

				if (stanza.from != null && JID.getBareId(stanza.from) == roomJid)
					return true;
			}
			
			return false;
		}
		
		public function collect(object:ISerializable):void
		{
			var stanza:Stanza = object as Stanza;
			
			if (stanza is Presence)
				presenceHandler(stanza as Presence);
			else if (stanza is Message)
				messageHandler(stanza as Message);
		}
		
		private function messageHandler(message:Message):void
		{
			if (message.type == Message.TypeGroupChat)
			{
				if (message.subject != null)
				{
	        		dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.SUBJECT_UPDATED, message));
				}
	        	else
	        	{
	        		dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.PUBLIC_MESSAGE, message));
	        	}
			}
			else if (message.type == Message.TypeChat)
			{
			}
			else if (message.type == Message.TypeNormal) // TODO: Handle invitation
			{
				dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.PRIVATE_MESSAGE, message));
			}
			else if (message.type == Message.TypeError)
			{
				dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.ERROR, message));
			}
		}

		private function presenceHandler(presence:Presence):void
		{	
			var from:String = presence.from;
			var isUserPresence:Boolean = isTheUser(from);
			
			var mucUser:MUCUser = presence.getChunk(MUCUser) as MUCUser;

			if (presence.type == null || presence.type == Presence.TypeAvailable)
			{				
				// Retrieve old occupant presence
				var oldPresence:Presence = occupants[from] as Presence;
				
				// Set new occupant presence
				occupants[from] = presence;
				
				// Check update in the new presence
				if (oldPresence != null)
				{
					var oldRole:String, newRole:String, oldAffiliation:String, newAffiliation:String;
					
					// Get the previous occupant's role & affiliation
					var oldMucUser:MUCUser = oldPresence.getChunk(MUCUser) as MUCUser;
					if (oldMucUser != null && oldMucUser.items != null && oldMucUser.items[0] != null)
					{
						oldRole = MUCUserItem(oldMucUser.items[0]).role;
						oldAffiliation = MUCUserItem(oldMucUser.items[0]).affiliation;
					}
							
					// Get the new occupant's role & affiliation	
					if (mucUser != null && mucUser.items != null && mucUser.items[0])
					{
						newRole = MUCUserItem(mucUser.items[0]).role;
						newAffiliation = MUCUserItem(mucUser.items[0]).affiliation;
					}
					
					// Check affiliation modification
					if (oldAffiliation != newAffiliation)
					{
						checkAffiliationModifications(oldAffiliation, newAffiliation, presence, isUserPresence);
					}
					// Check role modification
					else if (oldRole != newRole)
					{
						checkRoleModifications(oldRole, newRole, presence, isUserPresence);
					}
					// Others status modification
					else
					{		
						if (isUserPresence)
							dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.STATUS_UPDATED, presence));
						else
							dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_STATUS_UPDATED, presence));
					}
				}
				// This is a new occupant presence
				else
				{
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_JOINED, presence));
					
					if (isUserPresence)
					{
						if (mucUser != null && mucUser.statusCode[0] == MUCStatusCode.RoomCreated)
						{
							created = true;
							dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.CREATED, presence));
						}

						joined = true;
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.JOINED, presence));
					}
				}
			}
			else if (presence.type == Presence.TypeUnavailable)
			{			
				if (mucUser != null && mucUser.statusCode != null && mucUser.statusCode[0] != null)
				{
					// Fire events according to the received presence code
					checkPresenceCode(presence, mucUser, isUserPresence, from);
				}
				else
				{
					delete occupants[from];
						
					if (isUserPresence)
					{
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.LEAVED, presence));
						release();
					}
					else // An occupant has left the room
					{
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_LEAVED, presence));
					}
				}
			}
			else if (presence.type == Presence.TypeError)
			{
				dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.ERROR, presence));
			}
		}
		
		/**
		 * Fires notifications if the role of a room occupant has changed.
		 */
		private function checkRoleModifications(oldRole:String, newRole:String, presence:Presence, isUserPresence:Boolean):void
		{					
			// Voice was granted to a visitor
			if ((oldRole == MUCRole.None || oldRole == MUCRole.Visitor) && newRole == MUCRole.Participant)
			{
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.VOICE_GRANTED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_VOICE_GRANTED, presence));
			}
			// The participant's voice was revoked from the room
			else if (oldRole == MUCRole.Participant && (newRole == MUCRole.Visitor || newRole == MUCRole.None))
			{
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.VOICE_REVOKED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_VOICE_REVOKED, presence));
			}
			
			// Moderator privileges were granted to a participant
			if (oldRole != MUCRole.Moderator && newRole == MUCRole.Moderator)
			{
				if (oldRole == MUCRole.Visitor || oldRole == MUCRole.None)
				{
					if (isUserPresence)
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.VOICE_GRANTED, presence));
					else
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_VOICE_GRANTED, presence));
				}
				
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.MODERATOR_GRANTED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_MODERATOR_GRANTED, presence));
			}
			// Moderator privileges were revoked from a participant
			else if (oldRole == MUCRole.Moderator && newRole != MUCRole.Moderator)
			{
				if (newRole == MUCRole.Visitor || newRole == MUCRole.None)
				{
					if (isUserPresence)
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.VOICE_REVOKED, presence));
					else
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_VOICE_REVOKED, presence));
				}
				
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.MODERATOR_REVOKED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_MODERATOR_REVOKED, presence));
			}
  		}
  		
  		/**
  		 * Fires notification events if the affiliation of a room occupant has changed.
  		 */
  		private function checkAffiliationModifications(oldAffiliation:String, newAffiliation:String, presence:Presence, isUserPresence:Boolean):void
		{			
			// First check for revoked affiliation and then for granted affiliations. The idea is to
			// first fire the "revoke" events and then fire the "grant" events.

			// The user's ownership to the room was revoked
			if (oldAffiliation == MUCAffiliation.Owner && newAffiliation != MUCAffiliation.Owner)
			{
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OWNERSHIP_REVOKED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_OWNERSHIP_REVOKED, presence));
			}
			// The user's administrative privileges to the room were revoked
			else if (oldAffiliation == MUCAffiliation.Admin && newAffiliation != MUCAffiliation.Admin)
			{
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.ADMIN_REVOKED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_ADMIN_REVOKED, presence));
			}
			// The user's membership to the room was revoked
			else if (oldAffiliation == MUCAffiliation.Member && newAffiliation != MUCAffiliation.Member)
			{
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.MEMBERSHIP_REVOKED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_MEMBERSHIP_REVOKED, presence));
			}
			
			// The user was granted ownership to the room
			if (oldAffiliation != MUCAffiliation.Owner && newAffiliation == MUCAffiliation.Owner)
			{
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OWNERSHIP_GRANTED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_OWNERSHIP_GRANTED, presence));
			}
			// The user was granted administrative privileges to the room
			else if (oldAffiliation != MUCAffiliation.Admin && newAffiliation == MUCAffiliation.Admin)
			{
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.ADMIN_GRANTED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_ADMIN_GRANTED, presence));
			}
			// The user was granted membership to the room
			else if (oldAffiliation != MUCAffiliation.Member && newAffiliation == MUCAffiliation.Member)
			{
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.MEMBERSHIP_GRANTED, presence));
				else
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_MEMBERSHIP_GRANTED, presence));
			}
		}
		
		/**
		 * Fires events according to the received presence code.
		 */
		private function checkPresenceCode(presence:Presence, mucUser:MUCUser, isUserPresence:Boolean, from:String):void
		{
			var mucUserItem:MUCUserItem;
			
			var statusCode:int = mucUser.statusCode[0];
			
			// Check if an occupant was kicked from the room
			if (statusCode == MUCStatusCode.Kicked)
			{
				// Check if this occupant was kicked
				if (isUserPresence)
				{
					joined = false;
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.KICKED, presence));
					release();
				}
				else
				{
					delete occupants[presence.from];
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_KICKED, presence));
				}
			}
			// A user was banned from the room
			else if (statusCode == MUCStatusCode.Banned)
			{
				// Check if this occupant was banned
				if (isUserPresence)
				{
					joined = false;
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.BANNED, presence));
					release();
				}
				else
				{
					delete occupants[presence.from];
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_BANNED, presence));
				}
			}
			// A occupant has changed his nickname in the room
			else if (statusCode == MUCStatusCode.NewNickname)
			{
				if (isUserPresence)
				{
					mucUserItem = MUCUserItem(mucUser.items[0]);
					if (mucUserItem != null)
					{
						nickname = mucUserItem.nick;
						dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.NICKNAME_CHANGED, presence));
					}
				}
				else
				{
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.OCCUPANT_NICKNAME_CHANGED, presence));
				}
			}
			// A user's membership was revoked from the room
			else if (statusCode == MUCStatusCode.AffiliationChange)
			{
				// Check if this occupant's membership was revoked
				if (isUserPresence)
					dispatchEvent(new ConferenceRoomEvent(ConferenceRoomEvent.MEMBERSHIP_REVOKED, presence));
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