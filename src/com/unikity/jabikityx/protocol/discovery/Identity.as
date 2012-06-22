package com.unikity.jabikityx.protocol.discovery
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	/**
     * Represents the identity of a given XMPP entity. An entity may have many identities but all
     * the identities SHOULD have the same name.<p>
     * 
     * Refer to <a href="http://www.jabber.org/registrar/disco-categories.html">Jabber::Registrar</a>
     * in order to get the official registry of values for the <i>category</i> and <i>type</i> 
     * attributes.
     * 
     */
	public class Identity extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "identity";
		public static const NS:Namespace = DiscoveryInfo.NS;
		
		public var category:String;
		public var name:String;
		public var type:String;
		
		/**
         * Creates a new identity for an XMPP entity.
         * 
         * @param category the entity's category.
         * @param name the entity's name.
         * @param type the entity's type
         */
		public function Identity(category:String=null, name:String=null, type:String=null)	
		{
			super(ELEMENT, NS);
			
			this.category = category;
			this.name = name;
			this.type = type;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);	
			
			var xml:XML = object as XML;
			
			if (xml.@name.length() > 0) this.name = xml.@name;
			if (xml.@type.length() > 0) this.type = xml.@type;
			if (xml.@category.length() > 0) this.category = xml.@category;	
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;

			if (name) xml.@name = name;
			if (type) xml.@type = type;
			if (category) xml.@category = category;
			
			return xml;
		}
	}
}