package com.unikity.jabikity.protocol.core
{	
	import com.unikity.jabikity.utils.IdGenerator;
	
	public class IQ extends Stanza
	{
		public static const ELEMENT:String = "iq";

		/**
		 * This is used to specify that the <iq/> element is being used in 
		 * request mode, to retrieve information. 
		 * The actual subject of the request is specified using the namespace
		 * qualification of the <query/> subelement; 
		 * 
		 * Using the HTTP parallel, this is the equivalent of the GET verb.
		 */
		public static const TypeGet:String = "get";
		
		/**
		 * While IQ-get is used to retrieve data, the corresponding set type is
		 * used to send data and is the equivalent of the POST verb in the HTTP 
		 * parallel.
		 */
        public static const TypeSet:String = "set";
        
        /**
        * As shown in the JUD conversation, the result type <iq/> packet is used
        * to convey a result. Whether that result is Boolean (it worked, as 
        * opposed to it didn't work) or conveys information (such as the 
        * registration fields that were requested), each IQ-get or IQ-set 
        * request is followed by an IQ-result response, if successful.
        */
        public static const TypeResult:String = "result";
        
        /**
        * If not successful, the IQ-get or IQ-set request is followed not by an
        * IQ-result response, but by an error type response. In the same way 
        * that a subelement <error/> carries information about what went wrong 
        * in a <message type='error'/> element, so it also provides the same 
        * service for IQ-error elements.
        */
        public static const TypeError:String = "error";
        
        public function IQ(to:String=null, type:String=IQ.TypeGet)
        {
        	super(ELEMENT);
        	
        	if (id == null) 
        		id = IdGenerator.nextId();
        	
        	this.type = type;		
			this.to = to;
        }
	}
}