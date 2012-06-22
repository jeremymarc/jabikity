package com.unikity.netkity.filter
{
	public interface IFilterController
	{
		function registerInputFilter(filter:IFilter):void;
		
		function unregisterInputFilter(filter:IFilter):void;
		
		function hasInputFilter(filter:IFilter):Boolean;
		
		function registerOutputFilter(filter:IFilter):void;
		
		function unregisterOutputFilter(filter:IFilter):void;
		
		function hasOutputFilter(filter:IFilter):Boolean;
		
		function doInputFilter(input:String):String;
		
		function doOutputFilter(input:String):String;
	}
}