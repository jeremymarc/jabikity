package com.unikity.jabikityx.protocol.discovery
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
     * Represents the features offered by the item. This information helps requestors determine 
     * what actions are possible with regard to this item (registration, search, join, etc.) 
     * as well as specific feature types of interest, if any (e.g., for the purpose of feature 
     * negotiation).
     */
	public class Feature extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "feature";
		public static const NS:Namespace = DiscoveryInfo.NS;
		
		/**
		 * The feature's variable.
		 */
		public var variable:String;

		/**
		 * Creates a new feature offered by an XMPP entity or item.
		 * 
		 * @param variable the feature's variable.
		 */
		public function Feature(variable:String=null)
		{
			super(ELEMENT, NS);
			
			this.variable = variable;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);	
			
			var xml:XML = object as XML;
			
			if (xml.@['var'].length() > 0) this.variable = xml.@['var'];
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;

			if (variable) xml.@['var'] = variable;
			
			return xml;
		}
		
		public function toString():String
		{
			return variable;
		}
	}
}