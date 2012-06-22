package com.unikity.jabikityx.protocol.form
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	
	public class FormField extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "field";
		public static const NS:Namespace = DataForm.NS;
		
		public static const TypeBoolean:String = "boolean";
	    public static const TypeFixed:String = "fixed";
	    public static const TypeHidden:String = "hidden";
	    public static const TypeJidMulti:String = "jid-multi";
	    public static const TypeJidSingle:String = "jid-single";
	    public static const TypeListMulti:String = "list-multi";
	    public static const TypeListSingle:String = "list-single";
	    public static const TypeTextMulti:String = "text-multi";
	    public static const TypeTextPrivate:String = "text-private";
	    public static const TypeTextSingle:String = "text-single";
	    
	    /**
	    * Returns the variable name that the question is filling out.
	    */
	    public var name:String; // field-name
	    
	    /**
	    * Returns the label of the question which should give enough information to the user to
	    * fill out the form.
	    */
	    public var label:String; // field-label
	    
	    /**
	    * Returns an indicative of the format for the data to answer.
	    */
	    public var type:String; // field-type
	    
	    /**
	    * Returns a description that provides extra clarification about the question. This information
	    * could be presented to the user either in tool-tip, help button, or as a section of text
	    * before the question.
	    * 
	    * If the question is of type FIXED then the description should remain empty.
	    */
	    public var description:String;
	    
	    /**
	    * Returns true if the question must be answered in order to complete the questionnaire.
	    */
	    public var required:Boolean;
	    
	    public var values:Array;
	    public var options:Array;
	    
	    public function get value():* { return values[0]; }
	    
		public function FormField(name:String=null, type:String=FormField.TypeFixed, label:String=null, description:String=null)
		{
			super(ELEMENT, NS);
			
			values = new Array();
			options = new Array();
			
			this.name = name;
			this.label = label;
			this.type = type;
			this.description = description;
		}
		
		public function addValue(value:*):void
		{
			values.push(value);
		}
		
		public function addValues(values:Array):void
		{
			for each (var value:String in values)
				this.values.push(values);
		}
		
		public function addOption(option:FieldOption):void
		{
			options.push(option);
		}
		
		public function resetValues():void
		{
			values = new Array();
		}
		
		public function resetOptions():void
		{
			options = new Array();
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
								
			// Attributes
			if (xml.@['var'].length() > 0) this.name = xml.@['var'].toString();
			if (xml.@type.length() > 0) this.type = xml.@type;
			if (xml.@label.length() > 0) this.label = xml.@label;
			
			if (xml.desc.length() > 0) this.description = xml.desc;
			if (xml.required.length() > 0) this.required = true;
			
			// Values
			for each (var v:XML in xml.ns::value)
				addValue(String(v));				
			
			// Options
			var optionLabel:String;
			var optionValue:String;
			
			for each (var option:XML in xml.ns::option)
			{
				if (option.@label.length() > 0) 
				{
					optionLabel = option.@label;
					optionValue = option.value;					
					addOption(new FieldOption(optionValue, optionLabel));
				}
			}
		}
		
		override public function serialize():Object
		{			
			var xml:XML = super.serialize() as XML;

			if (name) xml.@['var'] = name;
			if (type) xml.@type = type;
			if (label) xml.@label = label;
			if (description) xml.desc = description;
			if (required) xml.appendChild(<required />);
			
			for each (var v:String in values)
				xml.appendChild(<value>{v}</value>); 
				
			for each (var opt:FieldOption in options)
				xml.appendChild(opt.serialize());
			
			return xml;
		}
		
		public function toString():String {
            return label;
        }
	}
}