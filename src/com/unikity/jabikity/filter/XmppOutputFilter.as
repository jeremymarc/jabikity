package com.unikity.jabikity.filter
{
	import com.unikity.netkity.filter.IFilter;
	
	public class XmppOutputFilter implements IFilter
	{
		public function onRegister():void
		{
			trace("XmppOutputFilter registered.");
		}
		
		public function onUnregister():void
		{
			trace("XmppOutputFilter unregistered.");
		}
		
		public function filter(input:String):String
		{
			// Stream open element with close tag
			if (input.indexOf("<stream:stream") >= 0 && input.indexOf("/>") >= 0)
				input = input.replace("/>", ">");
				
			return input;
		}
	}
}