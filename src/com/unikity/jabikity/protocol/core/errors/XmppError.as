package com.unikity.jabikity.protocol.core.errors
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	public class XmppError extends XmppChunk implements IXmppChunk
	{
		public function XmppError(elementName:String, ns:Namespace)
		{
			super(elementName, ns);
		}
	}
}