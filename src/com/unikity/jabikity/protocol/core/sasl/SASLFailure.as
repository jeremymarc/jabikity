package com.unikity.jabikity.protocol.core.sasl
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	// <failure xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>
	//		<incorrect-encoding/>
	// </failure>
	public class SASLFailure extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "failure";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-sasl");
		
		public var condition:String;

		public function SASLFailure(condition:String=null)
		{
			super(ELEMENT, NS);
			
			this.condition = condition;		
		}

		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			for each (var child:XML in xml.children())
			{
				if (SASLFailureCondition.isCondition(child.name().localName))
				{
					this.condition = child.name().localName;
					break;
				}
			}		
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (condition) xml.appendChild(<{condition}/>);
			
			return xml;
		}
	}
}