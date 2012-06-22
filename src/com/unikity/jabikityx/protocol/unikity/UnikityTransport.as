package com.unikity.jabikityx.protocol.unikity
{
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import com.unikity.jabikity.protocol.*;
	
	import flash.utils.ByteArray;
	
	/**
	 * Base64 Encoded AMF over XMPP transport layer extension
	 */
	public class UnikityTransport extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "x";
		public static const NS:Namespace = new Namespace("", "http://unikity.org/xmpp/transport");

		public var data:Object;
		
		public function UnikityTransport(data:Object=null)
		{
			super(ELEMENT, NS);
			
			this.data = data;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.ns::data.length() > 0) 
			{ 	
				var dataHex:String = Base64.decode(xml.ns::data);
				var dataArray:ByteArray = Hex.toArray(dataHex);	
				
				if (dataArray != null && dataArray.bytesAvailable > 0)
				{
					try
					{
						dataArray.uncompress();
						data = dataArray.readObject();
					}
					catch (e:Error)
					{
					}
				}
			}
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (data != null)
			{
				var dataArray:ByteArray = new ByteArray();
				dataArray.writeObject(data);
				dataArray.compress();
				
				var dataHex:String = Hex.fromArray(dataArray);

				xml.data = Base64.encode(dataHex);
			}
			
			return xml;
		}
	}
}