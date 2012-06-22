package com.unikity.netkity.authenticator
{
	import com.unikity.netkity.IConnection;
	import com.unikity.netkity.collector.ICollector;
	
	import flash.events.IEventDispatcher;
	
	public interface IAuthenticator extends IEventDispatcher, ICollector
	{
		function get authenticated():Boolean;
		
		function get connection():IConnection;
		function set connection(connection:IConnection):void;

		function authenticate():void;
		
		function authenticationSuccess():void;
		
		function authenticationFail(reason:Object):void;
		
		function authenticationError(error:Object):void;		
	}
}