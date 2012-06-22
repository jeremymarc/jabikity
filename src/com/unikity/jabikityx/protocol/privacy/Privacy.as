package com.unikity.jabikityx.protocol.privacy
{
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikity.protocol.core.JID;
	
	public class Privacy extends IQ
	{
		public static const ELEMENT:String = "query";
		public static const NS:Namespace = new Namespace("", "jabber:iq:privacy");
		
		public static const DEFAULT_NAMELIST:String = "privacy";
			
		public var items:Array;
		public var lists:Array;
		public var node:String;
		public var defaultAction:Boolean;
		public var activeList:String;
		public var defaultList:String
		public var setActiveList:Boolean;
		public var setDefaultList:Boolean;

		public function Privacy(type:String=null, jid:String=null)
		{
			super(jid, type);
			this.items = new Array();
			this.lists = new Array();
		}
		
		public function addList(listname:String):void
		{
			this.lists.push(listname);
		}
		
		public function addItem(item:PrivacyItem):void
		{
			this.items.push(item);
		}

		override public function deserialize(object:Object):void
		{
			super.deserialize(xml);
			
			var xml:XML = object as XML;
			
			var query:XML = xml..NS::query[0];
						
			if (query.active.length() > 0) this.activeList = query.active.@name;
			if (query['default'].length() > 0) this.defaultList = query['default'].@name;

			for each (var list:XML in query.NS::list)
			{
				var listname:String = list.@name; //get the privacy list names
				addList(listname);
			}
			
			if (lists.length > 0)
			{
				for each (var item:XML in query.NS::list[0].NS::item)
				{
					var privacyitem:PrivacyItem = new PrivacyItem();
					privacyitem.deserialize(item);
					addItem(privacyitem);
				}
			}
			super.deserialize(object);
		}
				
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			var query:XML = new XML(<{ELEMENT}/>);
			query.setNamespace(NS);
			
			if (node) query.@node = node;

			if (setDefaultList) 
				query['default'].@name = DEFAULT_NAMELIST; // set the default list
			else if (defaultList != null)
				query['default'].@name = defaultList;

			if (setActiveList) 
				query.active.@name = DEFAULT_NAMELIST; //set the active list
			else if (activeList != null) 
				query.active.@name = activeList; //set the active list
			
			if ((items.length > 0) && (lists.length == 0)) 
				lists.push(DEFAULT_NAMELIST);
				
			for each (var listname:String in lists)
			{
				var listNameXml:XML = <list name={listname} />;
				listNameXml.setNamespace(NS);
				query.appendChild(listNameXml);
			}
				
			if (lists.length == 1) // adding items is possible only if there is only one list
			{
				 for each (var item:PrivacyItem in items)
				 {
				 	var privacyXml:XML = item.serialize() as XML;
				 	privacyXml.setNamespace(NS);
				 	query.NS::list.appendChild(privacyXml);
				 }
			}

			xml.appendChild(query);

			return xml;
		}
	}
}