package com.unikity.jabikityx.form
{
	import com.unikity.jabikityx.protocol.form.DataForm;
	import com.unikity.jabikityx.protocol.form.FormField;
	
	import flash.errors.IllegalOperationError;
	
	public class Form
	{
		// The form-processing entity is asking the form-submitting entity to complete a form.
		public static const TypeForm:String = "form";
		
		// The form-submitting entity is submitting data to the form-processing entity. 
		// The submission MAY include fields that were not provided in the empty form, but the form-processing entity MUST ignore any fields that it does not understand.
		public static const TypeSubmit:String = "submit";
		
		// The form-submitting entity has cancelled submission of data to the form-processing entity.
		public static const TypeCancel:String = "cancel";
		
		// The form-processing entity is returning data (e.g., search results) to the form-submitting entity, or the data is a generic data set.
		public static const TypeResult:String = "result";
		
		private var form:DataForm;
		
		public function get type():String {
			return form.type;
		}
		
		public function set type(type:String):void {
			form.type = type;
		}
		
		public function get title():String {
			return form.title;
		}
		
		public function set title(title:String):void {
			form.title = title;
		}
		
		public function get fields():Array {
			return form.fields;
		}
		
		public function get instructions():Array {
			return form.instructions;
		}
		
		public function get items():Array {
			return form.items;
		}
		
		public function Form(form:DataForm)
		{
			this.form = form;
		}
		
		public function addField(field:FormField):void
		{
			form.addField(field);
		}
		
		public function removeField(name:String):void
		{
			form.removeField(name);
		}
		
		public function getField(name:String):FormField
		{
			return form.getField(name);
		}
		
		public function getFieldValue(name:String):*
		{
			return form.getFieldValue(name);
		}
		
		public function getBooleanFieldValue(name:String):Boolean
		{
			return form.getFieldValue(name) == "1" ? true : false;
		}
		
		public function hasField(name:String):Boolean
		{
			return form.getField(name) != null;
		}
		
		public function addInstruction(instruction:String):void
		{
			form.addInstruction(instruction);
		}
		
		public function addItem(itemFields:Array):void
		{
			form.addItem(itemFields);
		}
		
		public function removeItem(itemIndex:int):void
		{
			form.removeItem(itemIndex);
		}
		
		public function getItem(itemIndex:int):Array
		{
			return form.getItem(itemIndex);
		}
		
		public function addReported(name:String, type:String=null, label:String=null):void
		{
			form.addReported(name, type, label);
		}
		
		public function removeReported(name:String):void
		{
			form.removeReported(name);
		}
		
		public function getReported(name:String):FormField
		{
			return form.getReported(name);
		}
		
		public function resetReported():void
		{
			form.resetReported();
		}
		
		public function resetInstructions():void
		{
			form.resetInstructions();
		}
		
		public function resetFields():void
		{
			form.resetFields();
		}
		
		public function resetItems():void
		{
			form.resetItems();
		}
		
		public function setFieldAnswer(fieldName:String, value:*):void
		{
			if (type != TypeSubmit)
            	throw new IllegalOperationError("Cannot set an answer if the form is not of type \"submit\"");

			var field:FormField = form.getField(fieldName);
			if (field == null)
				throw new ArgumentError("Field not found for the specified variable name.");
			
			field.resetValues();
			
			if (value is Array)
				field.addValues(value);
			else if (value is Boolean)
				field.addValue(value ? "1" : "0");
			else
				field.addValue(value);
		}
		
		/**
		 * Returns a DataForm that serves to send this Form to the server. If the form is of type 
		 * submit, it may contain fields with no value. These fields will be removed since they only 
		 * exist to assist the user while editing/completing the form in a UI. 
		 * 
		 * @return the wrapped DataForm.
		 */
		public function getDataFormToSend():DataForm
		{
			if (form.type == TypeSubmit)
			{
				// Create a new DataForm that contains only the answered fields 
				var dataFormToSend:DataForm = new DataForm(type);
				for each (var field:FormField in form.fields)
				{
					if (field.value != null) {
						field.type = null;
						dataFormToSend.addField(field);
					}
				}
				return dataFormToSend;
			}
			
			return form;
		}
		
		/**
		 * Returns a new Form to submit the completed values. The new Form will include all the fields
		 * of the original form except for the fields of type FIXED. Only the HIDDEN fields will 
		 * include the same value of the original form. The other fields of the new form MUST be 
		 * completed. If a field remains with no answer when sending the completed form, then it won't 
		 * be included as part of the completed form.
		 * 
		 * The reason why the fields with variables are included in the new form is to provide a model 
		 * for binding with any UI. This means that the UIs will use the original form (of type 
		 * "form") to learn how to render the form, but the UIs will bind the fields to the form of
		 * type submit.
		 * 
		 * @return a Form to submit the completed values.
		 */
		public function createAnswerForm():Form
		{
			if (type != Form.TypeForm)
				throw new IllegalOperationError("Only forms of type \"form\" could be answered");
				
			// Create a new Form
			var answerDataForm:DataForm = new DataForm(TypeSubmit);			
			var answerForm:Form = new Form(answerDataForm);
			
			// Add to the new form any type of field that includes a variable.
			for each (var field:FormField in form.fields)
			{
				if (field.name != null)
				{
					var newField:FormField = new FormField(field.name, field.type);
					answerForm.addField(newField);
					
					// Set the answer ONLY to the hidden fields 
					if (field.type == FormField.TypeHidden)
						newField.addValues(field.values);
				}
			}
			
			return answerForm;
		}
	}
}