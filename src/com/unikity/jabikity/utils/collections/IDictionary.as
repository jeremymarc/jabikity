package com.unikity.jabikity.utils.collections
{	
	public interface IDictionary
	{
		function get count():uint;
		function contains(key:*):Boolean;
		function getValue(key:*):*;
		function add(key:*, value:*):void;
		function remove(key:*):void;
	}
}