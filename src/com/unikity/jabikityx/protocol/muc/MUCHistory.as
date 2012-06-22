package com.unikity.jabikityx.protocol.muc
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	import com.unikity.jabikity.utils.DateUtil;

	/**
	 * The History class controls the number of characters or messages to receive
	 * when entering a room.
	 */
	public class MUCHistory extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "history";
		public static const NS:Namespace = MUC.NS;
		
		/**
		 * Returns the total number of characters to receive in the history.
		 */
		public var maxChars:int = -1;
		
		/**
		 * Returns the total number of messages to receive in the history.
		 */
		public var maxStanzas:int = -1;
		
		/**
		 * Returns the number of seconds to use to filter the messages received during that time. 
         * In other words, only the messages received in the last "X" seconds will be included in 
         * the history.
         */
		public var seconds:int = -1;
		
		/**
		 * Returns the since date to use to filter the messages received during that time. 
         * In other words, only the messages received since the datetime specified will be 
         * included in the history.
         */ 
		public var since:Date;
		
		public function MUCHistory()
		{
			super(ELEMENT, NS);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@maxchars.length() > 0) maxChars = xml.@maxchars;
			if (xml.@maxstanzas.length() > 0) maxStanzas = xml.@maxstanzas;
			if (xml.@seconds.length() > 0) seconds = xml.@seconds;
			if (xml.@since.length() > 0) since =  DateUtil.toISO8601Date(xml.@since);
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (maxChars != -1) xml.@maxchars = maxChars;
			if (maxStanzas != -1) xml.@maxstanzas = maxStanzas;
			if (seconds != -1) xml.@seconds = seconds;
			if (since != null) xml.@since = DateUtil.toISO8601String(since);
			
			return xml;
		}
	}
}