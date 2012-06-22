package com.unikity.netkity.collector
{
	import com.unikity.netkity.serializer.ISerializable;
	
	public interface ICollectorController
	{
		function registerCollector(collector:ICollector):void;
		
		function unregisterCollector(collector:ICollector):void;
		
		function hasCollector(collector:ICollector):Boolean;		
	
		function collect(object:ISerializable):void;	
	}
}