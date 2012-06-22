package com.unikity.jabikity.protocol.core
{	
	public class Message extends Stanza
	{
		public static const ELEMENT:String = "message";
		
		/**
		 * The normal message type is used for simple messages that are often 
		 * one-time in nature, similar to an email message. If I send you a 
		 * message and I'm not particularly expecting a response, or a 
		 * discussion to ensue, then the appropriate message type is normal.
		 * 
		 * Some clients handle normal message types by placing them in a sort 
		 * of message inbox, to be viewed by the user when he so chooses. 
		 * This is in contrast to a chat type message.
		 * 
		 * Note that the normal message type is the default. So if a message 
		 * is received without an explicit type attribute, it is interpreted 
		 * as being normal.
		 */
    	public static var TypeNormal:String = "normal";

    	/**
    	 * The chat message type differs from the normal message type in that 
    	 * it carries a message that is usually part of a live conversation, 
    	 * which is best handled in real time with immediate responses—a chat
    	 * session.
    	 * 
    	 * The handling of chat messages in many clients is done with a single 
    	 * window that displays all the chat messages both sent and received 
    	 * between the two parties involved—all the chat messages that belong 
    	 * to the same thread of conversation, that is. There's a subelement of
    	 * the <message/> element that allows the identification of 
    	 * conversational threads so that the right messages can be grouped 
    	 * together; see the information on <thread/>
    	 */
    	public static var TypeChat:String = "chat";

    	/**
    	 * The groupchat message type is to alert the receiving client that the
    	 * message being carried is one from a conference (groupchat) room. 
    	 * The user can participate in many conference rooms and receive
    	 * messages sent by other participants in those rooms. The groupchat 
    	 * type signifies to the receiving client that the address specified in
    	 * the from attribute (see later in this section) is not the sending 
    	 * user's real JID but the JID representing the sending user, 
    	 * via her nickname, in the conference room from where the groupchat 
    	 * message originates.
    	 * 
    	 * Also, groupchat type messages, such as those announcing entrances or 
    	 * exits of room participants, can be received from the room itself.
    	 */
        public static var TypeGroupChat:String = "groupchat";

    	/**
    	 * This is a special message type designed to carry news style 
    	 * information, often accompanied by a URL and description in an 
    	 * attachment qualified by the jabber:x:oob namespace. 
    	 * Messages with their type set to headline can be handled by clients
    	 * in such a way that their content is placed in a growing list of 
    	 * entries that can be used as reference by the user.
    	 */
        public static var TypeHeadline:String = "headline";

    	/**
    	 * The error message type signifies that the message is conveying error
    	 * information to the client. Errors can originate in many places and 
    	 * under many circumstances. Refer to the description of the <error/> 
    	 * subelement.
    	 */
        public static var TypeError:String = "error";
        
        /**
    	 * The body of the message beind sent or received.
    	 */
		public var body:String;
		
    	/**
    	 * The subject of a TYPE_HEADLINE or TYPE_NORMAL message. For multi user
    	 * chat, this property contains the topic of the room.
    	 */
		public var subject:String;
		
    	/**
		 * The <thread/> subelement is used by clients to group together 
		 * snippets of conversations (between users) so that the whole 
		 * conversation can be visually presented in a meaningful way. 
		 * Typically a conversation on a particular topic—a thread—will be 
		 * displayed in a single window. Giving each conversation thread an 
		 * identity enables a distinction to be made when more than one 
		 * conversation is being held at once and chat type messages, which are
		 *  component parts of these conversations, are being received 
		 * (possibly from the same correspondent) in an unpredictable sequence.
		 * 
		 * Only when a new topic or branch of conversation is initiated must a 
		 * client generate a thread value. At all other times, the correspondent
		 * client must simply include the <thread/> tag in the response. 
		 * 
		 * Here the thread value is generated from a hash of the message 
		 * originator's JID and the current time.
		 */
		public var threadId:String;
				
        public function Message(to:String=null, type:String=null, body:String=null, subject:String=null, threadId:String=null)
        {
        	super(ELEMENT);

			this.to = to;
			this.body = body;
			this.subject = subject;
			this.threadId = threadId;	
			this.type = type;
        }
        
        override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.subject.length() > 0) subject = xml.subject;
			if (xml.body.length() > 0) body = xml.body;
			if (xml.thread.length() > 0) threadId = xml.thread;
		}
			
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (subject != null) xml.subject = subject;
			if (threadId != null) xml.thread = threadId;
			if (body != null) xml.body = body;
			
			return xml;
		}	
	}
}