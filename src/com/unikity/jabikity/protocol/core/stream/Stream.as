package com.unikity.jabikity.protocol.core.stream
{
	import com.unikity.jabikity.protocol.core.*;
	import com.unikity.jabikityx.protocol.discovery.Feature;

	public class Stream extends Stanza
	{ 
		public static const ELEMENT:String = "stream";
		public static const NS:Namespace = new Namespace("stream", "http://etherx.jabber.org/streams");
		
		public static const STREAM_ERROR_NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-streams");
		public static const CLIENT_NS:Namespace = new Namespace("", "jabber:client");
		
		public var version:String;
		
		public var features:Array;
		
		public function Stream(to:String=null, version:String=null)
		{
			super(ELEMENT, NS);
			
			features = new Array();
			
			this.to = to;
			this.version = version;
		}
		
		public function addFeature(feature:Feature):void
		{
			features.push(feature);
		}
		
		public function resetFeatures():void
		{
			features = new Array();
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@version.length() > 0) version = xml.@version;
			
			var t:XMLList = xml.ns::features.*;
			
			for each (var xmlFeature:XML in xml.ns::features.*)
			{
				var feature:Feature = new Feature();
				feature.deserialize(xmlFeature);
				addFeature(feature);
			}
	
			var errorNS:Namespace = STREAM_ERROR_NS;
			if (xml.errorNS::error.length() > 0)
			{
				error = new StreamError();
				error.deserialize(xml.errorNS::error[0]);
			}
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;

			xml.addNamespace(CLIENT_NS);
			
			if (version) xml.@version = version;
			
			if (features.length > 0)
			{
				var xmlFeatures:XML = <features />;
				xmlFeatures.setNamespace(ns);
				
				for each (var feature:Feature in features)				
					xmlFeatures.appendChild(feature.serialize());
			}
			
			return xml;
		}
	}
}