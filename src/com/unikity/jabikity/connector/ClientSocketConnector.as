package com.unikity.jabikity.connector
{
	import com.unikity.jabikity.utils.net.RFC2817Socket;
	import com.unikity.netkity.*;
	import com.unikity.netkity.connector.*;
	
	import flash.events.*;
	import flash.system.Security;
	
	public class ClientSocketConnector extends Connector
	{
		protected var debug:Boolean;
		protected var socket:RFC2817Socket;

        public var proxyHost:String;
        public var proxyPort:int = -1;
        
        override public function get connected():Boolean { 
        	return socket.connected;
        }
        
		public function ClientSocketConnector(host:String, port:int, debug:Boolean=false)
		{
			this.host = host;
			this.port = port;
			this.debug = debug;
					
			socket = new RFC2817Socket();
			
			if (proxyHost != null && proxyPort != -1)
				socket.setProxyInfo(proxyHost, proxyPort);
				
			socket.addEventListener(Event.CLOSE, socketEventHandler, false, 0, true);
			socket.addEventListener(Event.CONNECT, socketEventHandler, false, 0, true);
            socket.addEventListener(ProgressEvent.SOCKET_DATA, socketEventHandler, false, 0, true);    
            socket.addEventListener(IOErrorEvent.IO_ERROR, socketEventHandler, false, 0, true);
        	socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketEventHandler, false, 0, true); 
		}
	
		override public function connect():void
		{
			try
            {
            	// http://www.igniterealtime.org/issues/browse/JM-537
            	Security.loadPolicyFile("xmlsocket://" + host + ":" + port);
            	
            	socket.connect(host, port);
            }
            catch (error:Error)
            {
            	dispatchEvent(new ConnectorEvent(ConnectorEvent.ERROR, error));
            }
		}
		
		override public function disconnect():void
		{
			try
            {
            	socket.close();
            	dispatchEvent(new ConnectorEvent(ConnectorEvent.DISCONNECT));
            }
            catch (error:Error)
            {
            	dispatchEvent(new ConnectorEvent(ConnectorEvent.ERROR, error));
            }
		}
		
		override public function send(data:String):void
		{
			dispatchEvent(new ConnectorEvent(ConnectorEvent.SEND_DATA, data));

			if (debug)
				trace("SENT:\n" + data);
			
			try
        	{
        		socket.writeUTFBytes(data);
            	socket.flush();
        	}
        	catch (error:Error)
        	{
        		dispatchEvent(new ConnectorEvent(ConnectorEvent.ERROR, error));
        	}
		}
		
		private function socketEventHandler(event:Event):void
		{
			switch (event.type)
			{
				case Event.CONNECT:
					dispatchEvent(new ConnectorEvent(ConnectorEvent.CONNECT));
					break;
					
				case Event.CLOSE: // Only dispatched when the server close the connection
					dispatchEvent(new ConnectorEvent(ConnectorEvent.DISCONNECT));
					break;
					
				case ProgressEvent.SOCKET_DATA:
					handleReceivedData(event as ProgressEvent);
					break;
					
				case IOErrorEvent.IO_ERROR:
					dispatchEvent(new ConnectorEvent(ConnectorEvent.ERROR, IOErrorEvent(event).text));
					break;
					
				case SecurityErrorEvent.SECURITY_ERROR:
					dispatchEvent(new ConnectorEvent(ConnectorEvent.ERROR, SecurityErrorEvent(event).text));
					break;
			}
		}
		
		private function handleReceivedData(event:ProgressEvent):void
		{			
			try
			{
				var data:String = socket.readUTFBytes(socket.bytesAvailable);
				
				if (debug)
					trace("RECV:\n" + data);
					
				dispatchEvent(new ConnectorEvent(ConnectorEvent.RECEIVE_DATA, data));
			}
			catch (error:Error)
			{
				if (debug)
					trace("Connection error: " + error.message);
					
				dispatchEvent(new ConnectorEvent(ConnectorEvent.ERROR, error));
			}
		}
	}
}