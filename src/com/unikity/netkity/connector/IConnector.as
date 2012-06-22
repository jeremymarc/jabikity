package com.unikity.netkity.connector
{
	import flash.events.IEventDispatcher;
	
	public interface IConnector extends IEventDispatcher
	{
		function get host():String;
		function set host(host:String):void;
		
		function get port():int;
		function set port(port:int):void;
		
		function get connected():Boolean;
		
		function connect():void;
		function disconnect():void;
		function send(data:String):void;		
	}
}