package com.unikity.jabikity.protocol.core.errors
{
	public class StanzaError extends XmppError
	{
		public static const ELEMENT:String = "error";
		public static const NS:Namespace = new Namespace("", "urn:ietf:params:xml:ns:xmpp-stanzas");
		
		/**
    	 * do not retry (the error is unrecoverable)
    	 */
    	public static var TypeCancel:String = "cancel";
    	
    	/**
    	 * proceed (the condition was only a warning)
    	 */
    	public static var TypeContinue:String = "continue";
    	
    	/**
    	 * retry after changing the data sent
    	 */
    	public static var TypeModify:String = "modify";
    	
    	/**
    	 * retry after providing credentials
    	 */
    	public static var TypeAuth:String = "auth";
    	
    	/**
    	 * retry after waiting (the error is temporary)
    	 */
    	public static var TypeWait:String = "wait";
    	
    	private var _type:String;
		private var _code:int;
		private var _condition:String;
		private var _text:String;
		private var _lang:String;
		
		public function get type():String { return _type; }
		public function set type(value:String):void { _type = value; }
		
		public function get code():int { return _code; }
		public function set code(value:int):void { _code = value; }
		
		public function get condition():String { return _condition; }
		public function set condition(value:String):void { _condition = value; }
		
		public function get text():String { return _text; }
		public function set text(value:String):void { _text = value; }
		
		public function get lang():String { return _lang; }
		public function set lang(value:String):void { _lang = value; }
		    			
		public function StanzaError(type:String=null, condition:String=null, text:String="", code:int=-1, lang:String=null)
		{
			super(ELEMENT, NS);
			
			this.type = type;
			this.code = code;
			this.condition = condition;
			this.text = text;
			this.lang = lang;
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			if (xml.@code.length() > 0) this.code = xml.@code;
			if (xml.@type.length() > 0) this.type = xml.@type;

			for each (var child:XML in xml.children())
			{
				if (StanzaCondition.isCondition(child.name().localName))
				{
					this.condition = child.name().localName;
				}
				else if (child.name().localName == "text")
				{
					this.text = String(child.valueOf());
					if (child.@lang.length() > 0) this.lang = child.@lang;
				}
			}
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
		
			if (code != -1) xml.@code = code;
			if (type != null) xml.@type = type;
			if (text != "") xml.ns::text = text;
			if (lang != null) xml.ns::text.@lang = lang;
			if (condition != null)
				xml.appendChild(<{condition}/>);

			return xml;
		}
	}
}