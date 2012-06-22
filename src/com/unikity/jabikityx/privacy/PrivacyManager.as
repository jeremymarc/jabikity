package com.unikity.jabikityx.privacy
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikityx.protocol.privacy.*;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * XEP-0016: Privacy Lists
	 * http://www.xmpp.org/extensions/xep-0016.html
	 */
	public class PrivacyManager { }
	/*public class PrivacyManager extends Observable implements IObservable
	{
		private static const BLOCKUSER_ACTION:String = "deny";
			
		protected var connection:XmppConnection;
		protected var blockedUsers:ArrayCollection;
		
		public function PrivacyManager(connection:XmppConnection)
		{
			this.connection = connection;
		}

		public function getPrivacyItems(responder:Function=null, listName:String=null):void
		{
			var privacy:Privacy = new Privacy(IQ.TYPE_GET);
			if (listName != null)
				privacy.lists.push(listName);
			else
				privacy.lists.push(Privacy.DEFAULT_NAMELIST);
				
			connection.addIQResponder(privacy, responder);
			connection.send(privacy);
		}
		
		public function getPrivacyList(responder:Function):void
		{
			var privacy:Privacy = new Privacy(IQ.TYPE_GET);
			
			connection.addIQResponder(privacy, responder);
			connection.send(privacy);
		}

		private function onGetPrivacyItems(p:IQ):void
		{
			blockedUsers = new ArrayCollection(Privacy(p).items);
			
			if (p.type == IQ.TYPE_RESULT)
				sendNotification(PrivacyNotification.GETITEMS, this.blockedUsers);
			else
				sendNotification(PrivacyNotification.ERROR);
		}
		
		
		public function changeActiveList(activeListName:String, callback:Function=null):void
		{
			var privacy:Privacy = new Privacy(IQ.TYPE_SET);
			privacy.activeList = activeListName;
			
			connection.addIQResponder(privacy, callback);
			connection.send(privacy);
		}
		
		public function changeDefaultList(defaultListName:String, callback:Function=null):void
		{
			var privacy:Privacy = new Privacy(IQ.TYPE_SET);
			privacy.defaultList = defaultListName;
			
			connection.addIQResponder(privacy, callback);
			connection.send(privacy);
		}
				
		public function blockUser(value:String, isPresenceIn:Boolean=false, isPresenceOut:Boolean=false, isMessage:Boolean=false, 
									isIq:Boolean=false, type:String=null, callback:Function=null, listName:String=null):void
		{
			var privacy:Privacy = new Privacy(IQ.TYPE_SET);
			for each (var item:PrivacyItem in blockedUsers)
			{
				if (item.value != value)
					privacy.items.push(item);
				else
				{
					sendNotification(PrivacyNotification.ALREADY_BLOCKED, this.blockedUsers);
					return;
				}
			}
				
			var privacyItem:PrivacyItem = new PrivacyItem(null, BLOCKUSER_ACTION, PrivacyItem.TYPE_JID);
			if (type != null) 
				privacyItem.type = type;
				
			privacyItem.value = value;
			privacyItem.order = 1;
			privacyItem.isPresenceIn = isPresenceIn;
			privacyItem.isPresenceOut = isPresenceOut;
			privacyItem.isMessage = isMessage;
			privacyItem.isIq = isIq;
			privacy.items.push(privacyItem);
			blockedUsers.addItem(privacyItem);
			
			connection.addIQResponder(privacy, callback);
			connection.send(privacy);
		}
		
		public function unblockUser(value:String, callback:Function=null):void
		{
			var privacy:Privacy = new Privacy(IQ.TYPE_SET);
			var i:int = 0;
			for each(var item:PrivacyItem in blockedUsers)
			{
				if (item.value != value)
					privacy.items.push(item);
				else
					this.blockedUsers.removeItemAt(i);
				i++;
			}
			
			connection.addIQResponder(privacy, callback);
			connection.send(privacy);
		}
	}*/
}