package com.unikity.jabikity.filter
{
	import com.unikity.jabikity.utils.StringUtils;
	import com.unikity.netkity.filter.IFilter;
	
	public class XmppInputFilter implements IFilter
	{
		public function onRegister():void
		{
			trace("XmppInputFilter registered.");
		}
		
		public function onUnregister():void
		{
			trace("XmppInputFilter unregistered.");
		}
		
		public function filter(input:String):String
		{
			// Add xml namespace for all xml:lang found in input data
			if (input.indexOf("xml:lang=") >= 0)
				input = StringUtils.replace(input, "xml:lang=", "xmlns:xml=\"http://www.w3.org/XML/1998/namespace\" xml:lang=");
			
			// Stream open element with no stream close element
			if (input.indexOf("<stream:stream") >= 0 && input.indexOf("</stream:stream>") < 0 && input.indexOf("<stream:features>") >= 0)
				input = input + "</stream:stream>";
				
			// Add stream close tag for features (this data is concatenated with the previous stream element received)
			if (input.indexOf("<stream:stream") < 0 && input.indexOf("<stream:features>") >= 0)
				input = input + "</stream:stream>";			
			
			// Stream close element with no stream open element
			if (input.indexOf("</stream:stream>") >= 0 && input.indexOf("<stream:stream") < 0 && input.indexOf("<stream:features") < 0)
			{
				var index:int = input.indexOf("</stream:stream>");
				input = input.substr(0, index);
				input += "<stream:stream xmlns:stream='http://etherx.jabber.org/streams'></stream:stream>";
			}
			
			// Stream error element with no stream namespace
			if (input.indexOf("<stream:error>") >= 0)
				input = input.replace("<stream:error>", "<stream:error xmlns:stream=\"http://etherx.jabber.org/streams\">");
				
			return input;
		}
	}
}