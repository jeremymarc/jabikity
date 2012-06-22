package com.unikity.jabikityx.privatestorage
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.core.IQ;
	import com.unikity.jabikityx.protocol.privatestorage.PrivateStorage;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PrivateStorageManager implements IEventDispatcher
	{
		protected var eventDispatcher:IEventDispatcher;
		protected var connection:XmppConnection;
		
		public function PrivateStorageManager(connection:XmppConnection)
		{
			eventDispatcher = new EventDispatcher(this);
			this.connection = connection;
		}
	
		public function retrieveData(childElement:String, xmlns:String):void
		{
			var xml:XML = new XML("<" + childElement + "/>");
			xml.setNamespace(new Namespace("", xmlns));
			
			var privateStorage:PrivateStorage = new PrivateStorage();
			privateStorage.xml = xml;
			
			var iq:IQ = new IQ(null, IQ.TypeGet);
			iq.addChunk(privateStorage);
			
			connection.addIQResponder(iq, 
				function(iq:IQ):void
				{
					var privateStorage:PrivateStorage = iq.getChunk(PrivateStorage) as PrivateStorage;
					if (privateStorage && iq.type == IQ.TypeResult)
						dispatchEvent(new PrivateStorageEvent(PrivateStorageEvent.DATA_RECEIVED, privateStorage.xml));
					else
						dispatchEvent(new PrivateStorageEvent(PrivateStorageEvent.ERROR, iq));
				});	
				
			connection.send(iq);
		}

		public function storeData(xml:XML):void
		{
			var privateStorage:PrivateStorage = new PrivateStorage();
			privateStorage.xml = xml;
			
			var iq:IQ = new IQ(null, IQ.TypeSet);
			iq.addChunk(privateStorage);
			
			connection.addIQResponder(iq, 
				function(iq:IQ):void
				{
					var privateStorage:PrivateStorage = iq.getChunk(PrivateStorage) as PrivateStorage;
					if (privateStorage && iq.type == IQ.TypeResult)
						dispatchEvent(new PrivateStorageEvent(PrivateStorageEvent.DATA_STORED, privateStorage.xml));
					else
						dispatchEvent(new PrivateStorageEvent(PrivateStorageEvent.ERROR, iq));
				});	
			
			connection.send(iq);
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