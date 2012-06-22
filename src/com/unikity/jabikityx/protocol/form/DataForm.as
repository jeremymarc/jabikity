package com.unikity.jabikityx.protocol.form
{
	import com.unikity.jabikity.protocol.*;
	
	/**
	 * Represents a form that could be use for gathering data as well as for reporting data
	 * returned from a search.
	 */
	public class DataForm extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "x";
		public static const NS:Namespace = new Namespace("", "jabber:x:data");
		
		// The form-processing entity is asking the form-submitting entity to complete a form.
		public static const TypeForm:String = "form";
		
		// The form-submitting entity is submitting data to the form-processing entity. 
		// The submission MAY include fields that were not provided in the empty form, but the form-processing entity MUST ignore any fields that it does not understand.
		public static const TypeSubmit:String = "submit";
		
		// The form-submitting entity has cancelled submission of data to the form-processing entity.
		public static const TypeCancel:String = "cancel";
		
		// The form-processing entity is returning data (e.g., search results) to the form-submitting entity, or the data is a generic data set.
		public static const TypeResult:String = "result";
		
		/**
		 * Returns the meaning of the data within the context. The data could be part of a form
		 * to fill out, a form submission or data results.
		 */
		public var type:String;
		
		/**
		 * Returns the description of the data. It is similar to the title on a web page or an X 
		 * window.  You can put a <title/> on either a form to fill out, or a set of data results.
		 */
		public var title:String;
				
		/**
		 * A data form of type "form", "submit", or "result" SHOULD contain at least one <field/> element; 
		 * a data form of type "cancel" SHOULD NOT contain any <field/> elements.
		 */
		public var fields:Array;
				
		/**
		 * Returns list of instructions that explain how to fill out the form and
		 * what the form is about. The dataform could include multiple instructions since each
		 * instruction could not contain newlines characters. Join the instructions together in order
		 * to show them to the user.
		 */
		public var instructions:Array;
		
		/**
		 * Returns the fields that will be returned from a search.
		 * 
		 * Therefore, a data form of type "result" MAY contain two child elements not described in the basic syntax above:
		 * One and only <reported/> element, which can be understood as a "table header" describing the data to follow.
		 * Zero or more <item/> elements, which can be understood as "table cells" containing data (if any) that matches the request.
		 */
		public var reported:Array;
		
		/**
		 * Returns the items returned from a search.
		 */
		public var items:Array;
		
				
		public function DataForm(type:String=null)
		{
			super(ELEMENT, NS);
			
			this.type = type;
			
			instructions = new Array();
			fields = new Array();
			reported = new Array();
			items = new Array();
		}
		
		/**
		 * Adds a new field as part of the form.
		 * 
		 * @param field the field to add to the form.
		 */
		public function addField(field:FormField):void
		{
			if (field.name != null)
				fields[field.name] = field;
		}
		
		public function removeField(name:String):void
		{
			delete fields[name];
		}
		
		public function getField(name:String):FormField
		{
			return fields[name] as FormField;
		}
		
		public function getFieldValue(name:String):*
		{
			var field:FormField = fields[name] as FormField;
			if (field != null)
				return field.value;
				
			return null;
		}
		
		public function addReported(name:String, type:String=null, label:String=null):void
		{
			var reported:FormField = new FormField(name, null, type, label);
			reported[reported.name] = reported;
		}
		
		public function removeReported(name:String):void
		{
			delete reported[name];
		}
		
		public function getReported(name:String):FormField
		{
			return reported[name] as FormField;
		}
		
		/**
		 * Adds a new item returned from a search.
		 * 
		 * @param item the item returned from a search.
		 */
		public function addItem(itemFields:Array):void
		{
			items.push(itemFields);
		}
		
		public function removeItem(itemIndex:int):void
		{
			delete items[itemIndex];
		}
		
		public function getItem(itemIndex:int):Array
		{
			return items[itemIndex];
		}
		
		/**
		 * Adds a new instruction to the list of instructions that explain how to fill out the form
		 * and what the form is about. The dataform could include multiple instructions since each 
		 * instruction could not contain newlines characters.
		 * 
		 * @param instruction the new instruction that explain how to fill out the form.
		 */
		public function addInstruction(instruction:String):void
		{
			instructions.push(instruction);
		}
		
		public function resetInstructions():void
		{
			instructions = new Array();
		}
		
		public function resetFields():void
		{
			fields = new Array();
		}
		
		public function resetReported():void
		{
			reported = new Array();
		}
		
		public function resetItems():void
		{
			items = new Array();
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;
			
			// Attributes
			if (xml.@type.length() > 0) this.type = xml.@type;
			
			// Childs
			for each (var child:XML in xml.children())
			{
				var field:FormField;
				
				switch (child.name().localName)
				{
					case "title":
						this.title = child.valueOf().toString();
						break;
						
					case "instructions":
						addInstruction(child.valueOf().toString());
						break;
						
					case "field":
						field = new FormField();
						field.deserialize(child);
						addField(field);
						break;
						
					case "reported":
						for each (var reportedXml:XML in child.children()) 
	                	{
	                		field = new FormField();
	                		field.deserialize(reportedXml);
	                		addReported(field.name, field.type, field.label);
	                	}
						break;
						
					case "item":
						var itemFields:Array = new Array();
						for each (var xmlItem:XML in child.children()) 
	                	{
	                		field = new FormField();
	                		field.deserialize(xmlItem);
	                		itemFields.push(field);
	                	}
	                	addItem(itemFields);
						break;				
				}
			}
		}
		
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (type) xml.@type = type;
			if (title) xml.title = title;
		
			for each (var instructionsStr:String in instructions)
			{
				var xmlInstructions:XML = <instructions>{instructionsStr}</instructions>;
				xmlInstructions.setNamespace(ns);
				xml.appendChild(xmlInstructions);
			}
							
			for each (var field:FormField in fields)
				xml.appendChild(field.serialize());				

			if (reported.count > 0)
			{
				var reportedRoot:XML = <reported />;
				
				for each (var reportedField:FormField in reported)
					reportedRoot.appendChild(reportedField.serialize());

				xml.appendChild(reportedRoot);
			}
				
			var item:XML;
			
			for each (var itemFields:Array in items)
			{
				item = <item />;

				for each (var itemField:FormField in itemFields)
					item.appendChild(itemField.serialize());
					
				xml.appendChild(item);	
			}
			
			return xml;
		}
	}
}