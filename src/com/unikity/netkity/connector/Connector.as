package com.unikity.netkity.connector
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
		
	public class Connector implements IConnector
	{
		protected var eventDispatcher:IEventDispatcher;
		
		private var _host:String;
		private var _port:int;
		private var _connected:Boolean;
		
		public function get host():String { return _host; }
		public function set host(host:String):void { _host = host; }
		
		public function get port():int { return _port; }
		public function set port(port:int):void { _port = port; }
		
		public function get connected():Boolean { return _connected; }
		
		public function Connector()
		{
			eventDispatcher = new EventDispatcher(this);
		}
						
		public function connect():void 
		{
		}
		
		public function disconnect():void 
		{ 
		}
				
		public function send(data:String):void 
		{			
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