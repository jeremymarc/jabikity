package com.unikity.jabikityx.protocol.privacy
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	public class PrivacyItem extends XmppChunk implements IXmppChunk
	{	
		public static const ELEMENT:String = "item";
		public static const NS:Namespace = Privacy.NS;
		
		public static const TYPE_JID:String = "jid";
		public static const TYPE_GROUP:String = "group";
		public static const TYPE_SUBSCRIPTION:String = "subscription";
		
		private static const PRESENCE_IN:String = "presence-in";
		private static const PRESENCE_OUT:String = "presence-out";
		private static const MESSAGE:String = "message";
		private static const IQ:String = "iq";
				
		public var jid:String;
		public var action:String;
		public var type:String;
		public var value:String;
		public var order:int;
		public var isPresenceIn:Boolean;
		public var isPresenceOut:Boolean;
		public var isMessage:Boolean;
		public var isIq:Boolean;		

		public function PrivacyItem(jid:String=null, action:String=null, type:String=null)
		{
			super(ELEMENT, NS);
			
			this.jid = jid;
			this.action = action;
			this.type = type;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@jid.length() > 0)  this.jid = xml.@jid;
			if (xml.@action.length() > 0)  this.action = xml.@action;
			if (xml.@type.length() > 0) this.type = xml.@type;
			if (xml.@value.length() > 0) this.value = xml.@value;
			if (xml.@order.length() > 0) this.order = xml.@order;
			if (xml.NS::[PRESENCE_IN].length() > 0) this.isPresenceIn = true;
			if (xml.NS::[PRESENCE_OUT].length() > 0)  this.isPresenceOut = true;
			if (xml.NS::message.length() > 0)  this.isMessage = true;
			if (xml.NS::iq.length() > 0)  this.isIq = true;
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (jid) xml.@jid = jid;
			if (action) xml.@action = action;
			if (type) xml.@type = type;
			if (value) xml.@value = value;
			if (order) xml.@order = order;
			if (isPresenceIn) xml[PRESENCE_IN] = isPresenceIn;
			if (isPresenceIn) xml[PRESENCE_OUT] = isPresenceOut;
			if (isMessage) xml[MESSAGE] = isMessage;
			if (isIq) xml[IQ] = isIq;

			return xml;
		}
	}
}