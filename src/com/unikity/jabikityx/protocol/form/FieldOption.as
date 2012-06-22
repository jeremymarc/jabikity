package com.unikity.jabikityx.protocol.form
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
	 * Represents the available option of a given FormField.
	 */
	public class FieldOption extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "option";
		public static const NS:Namespace = DataForm.NS;
		
		public var label:String;
		public var value:String;
		
		public function FieldOption(value:String=null, label:String=null)
		{
			super(ELEMENT, NS);
			
			this.value = value;
			this.label = label;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@label.length() > 0) this.label = xml.@label;			
			if (xml.value.length() > 0) this.value = xml.value;
		}

		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (label) xml.@label = label;
			if (value) xml.value = value;

			return xml;
		}
	}
}