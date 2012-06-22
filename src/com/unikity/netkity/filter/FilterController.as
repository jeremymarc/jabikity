package com.unikity.netkity.filter
{
	public class FilterController implements IFilterController
	{
		protected var inputFilters:Array;
		protected var outputFilters:Array;
		
		public function FilterController()
		{
			inputFilters = new Array();
			outputFilters = new Array();
		}
		
		public function registerInputFilter(filter:IFilter):void
		{
			// register the filter
			inputFilters.push(filter);
			
			// alert the filter that it has been registered
			filter.onRegister();
		}
		
		public function unregisterInputFilter(filter:IFilter):void
		{
			for (var i:uint = 0; i < inputFilters.length; i++)
			{
				if (inputFilters[i] == filter)
                {
                	// alert the filter that it has been removed
                	filter.onUnregister();
                    inputFilters.splice(i, 1);
                    break;
                }
   			}
		}
		
		public function hasInputFilter(filter:IFilter):Boolean
		{
			for each (var f:IFilter in inputFilters)
			{
				if (f == filter)
					return true;
			}
			return false;
		}
		
		public function registerOutputFilter(filter:IFilter):void
		{
			// register the filter
			outputFilters.push(filter);
			
			// alert the filter that it has been registered
			filter.onRegister();
		}
		
		public function unregisterOutputFilter(filter:IFilter):void
		{
			for (var i:int = 0; i < outputFilters.length; i++)
			{
				if (outputFilters[i] == filter)
                {
                	// alert the filter that it has been removed
                	filter.onUnregister();
                    outputFilters.splice(i, 1);
                    break;
                }
   			}
		}
		
		public function hasOutputFilter(filter:IFilter):Boolean
		{
			for each (var f:IFilter in outputFilters)
			{
				if (f == filter)
					return true;
			}
			return false;
		}
		
		public function doInputFilter(input:String):String
		{
			var result:String = input;
			
			for each (var filter:IFilter in inputFilters)
				result = filter.filter(input)
			
			return result;
		}
		
		public function doOutputFilter(input:String):String
		{
			var result:String = input;
			
			for each (var filter:IFilter in outputFilters)
				result = filter.filter(input);
							
			return result;
		}
	}
}