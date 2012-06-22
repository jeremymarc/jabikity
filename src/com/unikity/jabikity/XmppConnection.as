package com.unikity.jabikity
{
	import com.unikity.jabikity.filter.*;
	import com.unikity.jabikity.listener.*;
	import com.unikity.jabikity.protocol.*;
	import com.unikity.jabikity.protocol.core.*;
	import com.unikity.jabikity.protocol.core.stream.Stream;
	import com.unikity.jabikity.serializer.*;
	import com.unikity.netkity.*;
	import com.unikity.netkity.authenticator.*;
	import com.unikity.netkity.connector.*;
	import com.unikity.netkity.serializer.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class XmppConnection extends Connection implements IEventDispatcher
	{
		protected var eventDispatcher:IEventDispatcher;
		
		public var id:String;
		public var resource:String = "jabikity";
		public var streamVersion:String = "1.0";
		public var features:Array;
		public var jid:String;
		public var ready:Boolean;
		
		protected var iqResponderMap:Array;
		private var _xmlBuffer:String = "";

		public function XmppConnection(connector:IConnector, authenticator:IAuthenticator=null)
		{
			super(connector, new XmppSerializer(), authenticator);
			
			eventDispatcher = new EventDispatcher(this);
			iqResponderMap = new Array();			
			registerDefaultFilters();
		}

		public function addIQResponder(element:IQ, responder:Function):void
		{
			iqResponderMap[element.id] = responder;
		}
		
		public function getIQResponder(element:IQ):Function
		{
			return iqResponderMap[element.id];
		}
		
		public function removeIQResponder(element:IQ):void
		{
			delete iqResponderMap[element.id];
		}
				
		private function registerDefaultInterceptors():void
		{
			registerCollector(new XmppConnectionListener(this));
			registerCollector(new IQResponderListener(this));
			registerCollector(new ClientCapabilitiesListener(this));
			registerCollector(new XmppPingListener(this));
		}
		
		private function registerDefaultFilters():void
		{
			registerInputFilter(new XmppInputFilter());
			registerOutputFilter(new XmppOutputFilter());
		}
		
		override public function disconnect():void
		{
			var presence:Presence = new Presence();
			presence.type = Presence.TypeUnavailable;
			send(presence);
		
			super.disconnect();
		}
				
		override protected function onConnect(event:ConnectorEvent):void
		{
			super.onConnect(event);
			dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.CONNECT));
		}
		
		override protected function onDisconnect(event:ConnectorEvent):void
		{
			super.onDisconnect(event);
			dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.DISCONNECT));
		}
		
		override protected function onSendData(event:ConnectorEvent):void
		{
			super.onSendData(event);
			dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.SEND_DATA, event.data));
		}
		
		override protected function onReceiveData(event:ConnectorEvent):void
		{
			super.onReceiveData(event);
			dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.RECEIVE_DATA, event.data));
		}
		
		override protected function onConnectionError(event:ConnectorEvent):void
		{
			super.onConnectionError(event);
			dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.ERROR, event.data));
		}
		
		override protected function onAuthenticationSuccess(event:AuthenticatorEvent):void
		{
			super.onAuthenticationSuccess(event);
			
			registerDefaultInterceptors();
			send(new Stream(host, streamVersion));
			
			dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.AUTHENTICATION_SUCCESS));
		}
		
		override protected function onAuthenticationFail(event:AuthenticatorEvent):void
		{
			super.onAuthenticationFail(event);
			dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.AUTHENTICATION_FAILED, event.data));
		}
		
		override protected function onAuthenticationError(event:AuthenticatorEvent):void
		{
			super.onAuthenticationError(event);
			dispatchEvent(new XmppConnectionEvent(XmppConnectionEvent.AUTHENTICATION_ERROR, event.data));
		}
				
		override protected function processFilteredData(data:String):void
		{
			// Bufferize element contain stream & features element if the server send it in two times
			if (data.indexOf("<?xml version='1.0' encoding='UTF-8'?><stream:stream") >= 0 && data.indexOf("<stream:features>") < 0)
			{
				_xmlBuffer += data;
			}
			else
			{
				_xmlBuffer += data;

				// Error handling to catch incomplete xml string that have been truncated by the socket
				var isComplete:Boolean = true;
				
				try
				{
					var xmlList:XMLList = new XMLList(_xmlBuffer);
				}
				catch (e:Error)
				{
					isComplete = false;
				}
				
				if (isComplete)
				{
					_xmlBuffer = ""; // reset data buffer
					
					for each (var xml:XML in xmlList)
					{
						var object:ISerializable = serializePacket(xml.toXMLString());
						if (object != null)
							collectPacket(object);
					}
				}
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