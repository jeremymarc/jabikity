package com.unikity.netkity.authenticator
{
	import com.unikity.netkity.IConnection;
	import com.unikity.netkity.serializer.ISerializable;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class Authenticator implements IAuthenticator
	{
		protected var _connection:IConnection;
		protected var _authenticated:Boolean;
		
		protected var eventDispatcher:IEventDispatcher;
				
		public function get authenticated():Boolean {
			return _authenticated; 
		}
		
		public function get connection():IConnection {
			return _connection;
		}
		
		public function set connection(connection:IConnection):void {
			_connection = connection;
		}

		public function Authenticator()
		{
			eventDispatcher = new EventDispatcher(this);
		}
		
		public function onRegister():void
		{
			trace("Authenticator collector registered.");
		}
		
		public function onUnregister():void
		{
			trace("Authenticator collector unregistered.");
		}
				
		public function filter(object:ISerializable):Boolean
		{
			return false;
		}
		
		public function collect(object:ISerializable):void
		{
		}
		
		public function authenticate():void
		{
		}
		
		public function authenticationSuccess():void
		{
			_authenticated = true;
			dispatchEvent(new AuthenticatorEvent(AuthenticatorEvent.AUTHENTICATION_SUCCESS));
		}
		
		public function authenticationFail(failure:Object):void
		{
			_authenticated = false;
			dispatchEvent(new AuthenticatorEvent(AuthenticatorEvent.AUTHENTICATION_FAIL, failure));
		}
		
		public function authenticationError(error:Object):void
		{
			_authenticated = false;
			dispatchEvent(new AuthenticatorEvent(AuthenticatorEvent.AUTHENTICATION_ERROR, error));
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