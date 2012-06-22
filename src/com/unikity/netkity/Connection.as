package com.unikity.netkity
{
	import com.unikity.netkity.authenticator.*;
	import com.unikity.netkity.collector.*;
	import com.unikity.netkity.connector.*;
	import com.unikity.netkity.filter.*;
	import com.unikity.netkity.serializer.*;
	
	public class Connection implements IConnection
	{
		protected var connector:IConnector;
		protected var authenticator:IAuthenticator;
		protected var serializer:ISerializer;
		protected var collectorController:ICollectorController;
		protected var filterController:IFilterController;
		
		public function get host():String { return connector.host; }
		public function get port():uint { return connector.port; }
		public function get connected():Boolean { return connector.connected; }
		public function get authenticated():Boolean { return authenticator.authenticated; }
		
		public function Connection(connector:IConnector, serializer:ISerializer, authenticator:IAuthenticator=null)
		{
			this.connector = connector;
			this.serializer = serializer;
			this.authenticator = authenticator;
			
			initializeSerializer();
			initializeCollectorController();
			initializeFilterController();
			initializeConnector();
			
			if (authenticator != null)
				initializeAuthenticator();
		}
				
		private function initializeSerializer():void
		{
			if (serializer != null) return;
			serializer = new Serializer();
		}
		
		private function initializeCollectorController():void
		{
			if (collectorController != null) return;
			collectorController = new CollectorController();
		}
		
		private function initializeFilterController():void
		{
			if (filterController != null) return;
			filterController = new FilterController();
		}

		private function initializeConnector():void
		{
			connector.addEventListener(ConnectorEvent.CONNECT, onConnect, false, 0, true);
			connector.addEventListener(ConnectorEvent.DISCONNECT, onDisconnect, false, 0, true);			
			connector.addEventListener(ConnectorEvent.SEND_DATA, onSendData, false, 0, true);
			connector.addEventListener(ConnectorEvent.RECEIVE_DATA, onReceiveData, false, 0, true);
			connector.addEventListener(ConnectorEvent.ERROR, onConnectionError, false, 0, true);
		}
		
		private function initializeAuthenticator():void
		{
			authenticator.connection = this;
			authenticator.addEventListener(AuthenticatorEvent.AUTHENTICATION_SUCCESS, onAuthenticationSuccess, false, 0, true);
			authenticator.addEventListener(AuthenticatorEvent.AUTHENTICATION_FAIL, onAuthenticationFail, false, 0, true);
			authenticator.addEventListener(AuthenticatorEvent.AUTHENTICATION_ERROR, onAuthenticationError, false, 0, true);
		}
		
		public function registerCollector(collector:ICollector):void
		{
			collectorController.registerCollector(collector);
		}
		
		public function unregisterCollector(collector:ICollector):void
		{
			collectorController.unregisterCollector(collector);
		}
		
		public function hasCollector(collector:ICollector):Boolean
		{
			return collectorController.hasCollector(collector);
		}
		
		public function registerInputFilter(filter:IFilter):void
		{
			filterController.registerInputFilter(filter);
		}
		
		public function unregisterInputFilter(filter:IFilter):void
		{
			filterController.unregisterInputFilter(filter);
		}
		
		public function hasInputFilter(filter:IFilter):Boolean
		{
			return filterController.hasInputFilter(filter);
		}
		
		public function registerOutputFilter(filter:IFilter):void
		{
			filterController.registerOutputFilter(filter);
		}
		
		public function unregisterOutputFilter(filter:IFilter):void
		{
			filterController.unregisterOutputFilter(filter);
		}
		
		public function hasOutputFilter(filter:IFilter):Boolean
		{
			return filterController.hasOutputFilter(filter);
		}
		
		public function connect():void
		{
			if (connector.connected)
				throw new ConnectionError("Connection already open.");
			
			connector.connect();
		}
		
		public function authenticate():void
		{
			if (authenticator == null)
				throw new ArgumentError("Please specify a valid authenticator.");
			
			// Authentication process start, register the authenticator collector
			registerCollector(authenticator);
			
			authenticator.authenticate();
		}
		
		public function disconnect():void
		{
			if (!connector.connected)
				return;
			
			connector.disconnect();
		}
		
		public function send(object:Object):void
		{
			if (!connector.connected)
				return;
			
			var output:String;
			
			if (object is ISerializable)
				output = serializer.deserialize(object as ISerializable);
			else
				output = object as String;
				
			// Filter the output data
			output = filterController.doOutputFilter(output);
			
			connector.send(output);
		}
		
		protected function onConnect(event:ConnectorEvent):void
		{
		}
		
		protected function onDisconnect(event:ConnectorEvent):void
		{
			// Authentication process terminated, unregister the authenticator collector
			if (hasCollector(authenticator))
				collectorController.unregisterCollector(authenticator);
		}
		
		protected function onSendData(event:ConnectorEvent):void
		{
		}
		
		protected function onReceiveData(event:ConnectorEvent):void
		{
			// Filter the received data
			var filteredData:String = filterController.doInputFilter(event.data);					
			processFilteredData(filteredData);
		}
		
		protected function onConnectionError(event:ConnectorEvent):void
		{
		}
		
		protected function onAuthenticationSuccess(event:AuthenticatorEvent):void
		{
			// Authentication process terminated, unregister the authenticator collector
			if (hasCollector(authenticator))
				collectorController.unregisterCollector(authenticator);
		}
		
		protected function onAuthenticationFail(event:AuthenticatorEvent):void
		{
			// Authentication process terminated, unregister the authenticator collector
			if (hasCollector(authenticator))
				collectorController.unregisterCollector(authenticator);
		}
		
		protected function onAuthenticationError(event:AuthenticatorEvent):void
		{
			// Authentication process terminated, unregister the authenticator collector
			if (hasCollector(authenticator))
				collectorController.unregisterCollector(authenticator);
		}
		
		protected function processFilteredData(filteredData:String):void
		{
		}
		
		protected function serializePacket(data:String):ISerializable
		{
			return serializer.serialize(data);
		}
		
		protected function collectPacket(object:ISerializable):void
		{
           	collectorController.collect(object);
		}
	}
}