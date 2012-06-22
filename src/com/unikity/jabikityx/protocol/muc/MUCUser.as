package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	  * Represents extended presence information about roles, affiliations, full JIDs,
	  * or status codes scoped by the 'http://jabber.org/protocol/muc#user' namespace.
	 */
	public class MUCUser extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "x";
		public static const NS:Namespace = new Namespace("", "http://jabber.org/protocol/muc#user");
		
		public static const TypeDecline:String = "decline";
		public static const TypeDestroy:String = "destroy";
		public static const TypeInvite:String = "invite";
		public static const TypeOther:String = "other";
		
		public var childType:String;
		public var password:String;
		public var host:String;
		public var invited:String;
		public var jid:String;		
		public var reason:String;
		public var continueThread:String;
		public var statusCode:Array;
		
		[ArrayElementType("com.unikity.jabikityx.protocol.muc.MUCUserItem")]
		public var items:Array;

		public function MUCUser()
		{
			super(ELEMENT, NS);
			
			items = new Array();
			statusCode = new Array();
		}
		
		public function addStatus(statusCode:int):void
		{
			this.statusCode.push(statusCode);
		}
		
		public function resetStatus():void
		{
			statusCode = new Array();
		}
		
		public function addItem(item:MUCUserItem):void
		{
			items.push(item);
		}
		
		public function resetItems():void
		{
			items = new Array();
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.ns::password.length() > 0) password = xml.ns::password;
			
			for each (var xmlStatusCode:XML in xml.ns::status)
				if (xmlStatusCode.@code.length() > 0) addStatus(xmlStatusCode.@code);
				
			for each (var xmlItem:XML in xml.ns::item)
			{
				var item:MUCUserItem = new MUCUserItem();
				item.deserialize(xmlItem);
				addItem(item);
			}
			
			var child:XML;
			
			if (xml.ns::invite.length() > 0)
			{
				childType = TypeInvite;
				if (xml.ns::invite.@from.length() > 0) host = xml.ns::invite.@from;
				if (xml.ns::invite.@to.length() > 0) invited = xml.ns::invite.@to;
				for each (child in xml.ns::invite.children())
				{
					switch(child.name().localName)
					{
						case "reason":
							this.reason = child.valueOf().toString();
							break;
						case "continue":
							this.continueThread = child.valueOf().toString();
							break;
					}
				}
			}
			else if (xml.ns::decline.length() > 0)
			{
				childType = TypeDecline;
				if (xml.ns::decline.@from.length() > 0) invited = xml.ns::decline.@from;
				if (xml.ns::decline.@to.length() > 0) host = xml.ns::decline.@to;
				for each (child in xml.ns::decline.children())
				{
					switch(child.name().localName)
					{
						case "reason":
							this.reason = child.valueOf().toString();
							break;
					}
				}
			}
			else if (xml.ns::destroy.length() > 0)
			{
				childType = TypeDestroy;
				
				if (xml.ns::destroy.@jid.length() > 0) jid = xml.ns::destroy.@jid;
				
				for each (child in xml.ns::destroy.children())
				{
					switch(child.name().localName)
					{
						case "reason":
							this.reason = child.valueOf().toString();
							break;
					}
				}
			}
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (password) xml.ns::password = password;
			
			var child:XML;
			
			if (childType)
			{
				child = <{childType}/>;
				child.setNamespace(NS);
				
				if (childType == MUCUser.TypeDecline)
				{				
					if (invited) child.@from = invited;
					if (host) child.@to = host;
				}
				else
				{
					if (host) child.@from = host;
					if (invited) child.@to = invited;
				}
				
				if (jid) child.@jid = jid;
				if (reason) child.reason = reason;
				
				xml.appendChild(child);
			}
			
			if (child && continueThread)
			{
				var xmlThread:XML = <continue />;
				xmlThread.setNamespace(NS);
				
				xmlThread.@thread = continueThread;
				child.appendChild(xmlThread);
			}
			
			for each (var code:int in this.statusCode)
			{
				var xmlStatus:XML = <status />;
				xmlStatus.setNamespace(NS);
				
				xmlStatus.@code = code;
				xml.appendChild(xmlStatus);
			}
			
			for each (var item:MUCUserItem in this.items)
				xml.appendChild(item.serialize());
			
			return xml;
		}
	}
}