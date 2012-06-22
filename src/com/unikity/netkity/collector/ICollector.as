package com.unikity.netkity.collector
{
	import com.unikity.netkity.serializer.ISerializable;
	
	public interface ICollector
	{
		function filter(object:ISerializable):Boolean;
		
		function collect(object:ISerializable):void;
		
		/**
         * Called when the collector is registered by the controller
         */
		function onRegister():void;
		
		/**
		 * Called when the collector is removed by the controller
		 */
		function onUnregister():void;
	}
}