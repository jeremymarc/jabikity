package com.unikity.jabikity.protocol.im
{
	import com.unikity.netkity.serializer.ISerializable;
	
	public class RosterItem implements ISerializable
	{	
		public static const ELEMENT:String = "item";
		public static const NS:Namespace = Roster.NS;
		
		public static const SubscriptionNone:String = "none";
		public static const SubscriptionTo:String = "to";
		public static const SubscriptionFrom:String = "from";
		public static const SubscriptionBoth:String = "both";
		public static const SubscriptionRemove:String = "remove";
	
		public var jid:String;
		public var name:String;
		public var subscription:String;
		public var groups:Array;
		
		
		public function RosterItem(jid:String=null, name:String=null)
		{
			this.jid = jid;
			this.name = name;
			
			groups = new Array();
		}
		
		private function addGroup(item:XML):void
		{
			groups.push(item.toString());
		}
		
		public function deserialize(object:Object):void
		{
			var xml:XML = object as XML;
			
			if (xml.@jid.length() > 0) this.jid = xml.@jid;				
			if (xml.@name.length() > 0) this.name = xml.@name;
			if (xml.@subscription.length() > 0) this.subscription = xml.@subscription;
			
			for each (var group:XML in xml.NS::group)
				addGroup(group);
		}
		
		public function serialize():Object
		{
			var xml:XML = <{ELEMENT}/>;
			
			if (jid) xml.@jid = jid;
			if (name) xml.@name = name;
			if (subscription) xml.@subscription = subscription;
			
			for each (var group:String in groups)
			{
				var groupXml:XML = <group>{group}</group>;
				groupXml.setNamespace(NS);
				xml.appendChild(groupXml);
			}				
		
			return xml;
		}
	}
}