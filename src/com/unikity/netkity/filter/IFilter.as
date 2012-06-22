package com.unikity.netkity.filter
{
	public interface IFilter
	{
		function filter(input:String):String;
		
		function onRegister():void;
		
		function onUnregister():void;
	}
}