package com.unikity.jabikity.protocol.core
{    
    /**
     * A JID represents a distinct entity on an XMPP network. It is more than just a
     * user. Users could have multiple JIDs, distinguished by different resources.
     * A JID is made up of a domain, node, and resource in the form of:
     * 
     * [ node "@" ] domain [ "/" resource ]
     * 
     * An example JID would be ddura@macromedia.com/Trillian. 
     * For more information JIDs see:
     * http://www.xmpp.org/specs/rfc3920.html#addressing
     */
    public class JID
    {	
    	public var node:String;
    	public var domain:String;
    	public var resource:String;
    	    	
    	public function get bareJid():JID { return new JID(bareId); }
    	
    	public function get bareId():String 
    	{
    		var n:String = (node) ? node : "";
    		var d:String = (domain) ? domain : "";
    		var at:String = (node && domain) ? "@" : "";
    		return n + at + d;
    	}
    	
    	public static function getBareId(jid:String):String
		{
			var r:Array = jid.split("/");	
			return r != null ? r[0] : null;
		}
		
		public static function getNode(jid:String):String
		{
			var r:Array = jid.split("@");
			return r != null ? r[0] : null;
		}
		
		public static function getResource(jid:String):String
		{
			var r:Array = jid.split("/");	
			return r != null && r[1] != null ? r[1] : null;
		}
    	
    	/**
    	 * @param jid A string representation of the JID in the form node@domain/resource
    	 */
    	public function JID(jid:String)
    	{
    		var a:Array = jid.split("@");
    	
    		if (a.length > 1)
    		{
    			node = a[0];    			
    			a = String(a[1]).split("/");
    		}
    		else
    		{
    			a = jid.split("/");
    		}
    		
    		domain = a[0];
    		
    		if (a.length > 1)
    			resource = a[1];
    	}
    	
    	/**
    	 * Returns a string representation of the JID in the form of:
    	 * 
    	 * [ node "@" ] domain [ "/" resource ]
    	 */
        public function toString():String
    	{
    		var jid:String = new String();
    		
    		if (node != "" && node != null)
                jid = node + "@";

            jid += domain;
    		if (resource != "" && resource != null)
                jid += "/" + resource;

            return jid;
    	}
        
        public function valueOf():String
        {
            return toString();
        }
        
        public function equals(jid:JID):Boolean
        {
        	return (node == jid.node) && 
        			(domain == jid.domain) && 
        			(resource == jid.resource);
        }  
    }
}