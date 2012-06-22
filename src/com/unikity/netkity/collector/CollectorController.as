package com.unikity.netkity.collector
{
	import com.unikity.netkity.serializer.ISerializable;
	
	import flash.utils.*;

	public class CollectorController implements ICollectorController
	{
		// list of collectors
        protected var collectors:Array;
        
        public function CollectorController()
        {
            collectors = new Array();
        }
		
		public function registerCollector(collector:ICollector):void
		{
			if (hasCollector(collector))
				throw new ArgumentError("This collector is already registered.");
				
			// register the collector
			collectors.push(collector);
			
			// alert the collector that it has been registered
			collector.onRegister();
		}
		
		public function unregisterCollector(collector:ICollector):void
        {
        	if (!hasCollector(collector))
				throw new ArgumentError("This collector is not registered.");
				
			// alert the collector that it has been removed
			collector.onUnregister();
			
			var n:int = collectors.length;		
			for (var i:int=0; i < n; i++)
            {
                if (collector == collectors[i]) {
                    collectors.splice(i, 1);
                    break;
                }
            }
        }
		
		public function hasCollector(collector:ICollector):Boolean
		{
			var n:int = collectors.length;
			for (var i:int=0; i < n; i++) 
            {
                if (collector == collectors[i])
                	return true;
            }
            
            return false;
		}
		
		public function collect(object:ISerializable):void
        {
        	for each (var collector:ICollector in collectors)
            {
            	if (collector.filter(object))
            		collector.collect(object);
            }
        }
	}
}