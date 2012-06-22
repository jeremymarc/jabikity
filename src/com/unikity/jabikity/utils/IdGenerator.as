package com.unikity.jabikity.utils
{
	public class IdGenerator
	{
		private static var _id:int = 0;		
		public static var prefix:String = "jab_";
		
		public static function nextId():String
		{
			return prefix + _id++;
		}
		
		public static function reset():void
		{
			_id = 0;
		}
	}
}