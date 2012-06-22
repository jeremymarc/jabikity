package com.unikity.jabikity.protocol.core.stream
{
	import com.unikity.jabikity.protocol.core.errors.XmppError;

	/**
	 * Represents a stream error element. Stream errors are unrecoverable errors where the server
	 * will close the unrelying TCP connection after the stream error was sent to the client.
	 * These is the list of stream errors as defined in the XMPP spec.
	 *
	 * @author Jeremy Marc
	 */
	public class StreamError extends XmppError
	{
		public static const ELEMENT:String = "error";
		public static const NS:Namespace = new Namespace("stream", "http://etherx.jabber.org/streams");

    	public var condition:String;
		public var text:String;
		public var lang:String;

		public function StreamError(condition:String=null, text:String=null, lang:String=null)
		{
			super(ELEMENT, NS);

			this.condition = condition;
			this.text = text;
			this.lang = lang;
		}

		override public function deserialize(object:Object):void
		{
			super.deserialize(object);

			var xml:XML = object as XML;

			if (xml.ns::text.length() > 0) this.text = xml.ns::text;
			if (xml.ns::text.@lang.length() > 0) this.lang = xml.ns::text.@lang;

			for each (var child:XML in xml.children())
				if (StreamCondition.isCondition(child.name().localName))
					this.condition = child.name().localName;
		}

		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			xml.setNamespace(ns);

			if (text) xml.ns::text = text;
			if (lang) xml.ns::text.@lang = lang;
			if (condition)
				xml.appendChild(new XML(<{condition}/>));

			return xml;
		}
	}
}
