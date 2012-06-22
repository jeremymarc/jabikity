package com.unikity.netkity
{
	import com.unikity.netkity.collector.ICollector;
	import com.unikity.netkity.filter.IFilter;
	
	public interface IConnection
	{
		function get host():String;
		function get port():uint;
		function get connected():Boolean;
		function get authenticated():Boolean;		
		
		/**
		 * Connection management
		 */
		function connect():void;
		function disconnect():void;
		function authenticate():void;
		function send(object:Object):void;

		/**
		 * Collectors management
		 */
		function registerCollector(collector:ICollector):void;
		function unregisterCollector(collector:ICollector):void;
		function hasCollector(collector:ICollector):Boolean;
				
		/**
		 * Filters management
		 */
		function registerInputFilter(filter:IFilter):void;
		function unregisterInputFilter(filter:IFilter):void;
		function hasInputFilter(filter:IFilter):Boolean;
		
		function registerOutputFilter(filter:IFilter):void;
		function unregisterOutputFilter(filter:IFilter):void;
		function hasOutputFilter(filter:IFilter):Boolean;
	}
}