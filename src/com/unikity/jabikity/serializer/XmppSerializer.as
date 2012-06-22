package com.unikity.jabikity.serializer
{
	import com.unikity.jabikity.protocol.*;
	import com.unikity.netkity.serializer.*;
	
	public class XmppSerializer extends Serializer
	{
		protected var xmppChunkFactory:XmppChunkFactory;
		
		public function XmppSerializer()
		{
			super();			
			xmppChunkFactory = XmppChunkFactory.getInstance();
		}
		
		override public function serialize(data:String):ISerializable
		{
			var xml:XML = new XML(data);
		
			var elementName:String = xml.name().localName;
			var ns:Namespace = xml.namespace();

			var chunk:IXmppChunk = xmppChunkFactory.retrieveXmppChunk(elementName, ns);
			if (chunk != null)
    			chunk.deserialize(xml);
  	
			return chunk;
		}
		
		override public function deserialize(object:ISerializable):String
		{
			return XML(object.serialize()).toXMLString();
		}
	}
}