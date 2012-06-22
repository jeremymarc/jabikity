package com.unikity.jabikity.protocol.core.errors
{
	public class StanzaCondition
	{
		/**
    	 * the sender has sent XML that is malformed or that cannot be processed (e.g., an IQ stanza that includes an unrecognized value of the 'type' attribute); the associated error type SHOULD be "modify".
    	 */
    	public static const BadRequest:String = "bad-request"; 
    		
    	/**
    	 * access cannot be granted because an existing resource or session exists with the same name or address; the associated error type SHOULD be "cancel".
    	 */
    	public static const Conflict:String = "conflict"; 
    		
    	/**
    	 * the feature requested is not implemented by the recipient or server and therefore cannot be processed; the associated error type SHOULD be "cancel".
    	 */
    	public static const FeatureNotImplemented:String = "feature-not-implemented"; 
    	
    	/**
    	 * the requesting entity does not possess the required permissions to perform the action; the associated error type SHOULD be "auth".
    	 */
    	public static const Forbidden:String = "forbidden"; 
    		
    	/**
    	 * the recipient or server can no longer be contacted at this address (the error stanza MAY contain a new address in the XML character data of the <gone/> element); the associated error type SHOULD be "modify".
    	 */
    	public static const Gone:String = "gone"; 
    	
    	/**
    	 * the server could not process the stanza because of a misconfiguration or an otherwise-undefined internal server error; the associated error type SHOULD be "wait".
    	 */
    	public static const InternalServerError:String = "internal-server-error"; 
    	
    	/**
    	 * the addressed JID or item requested cannot be found; the associated error type SHOULD be "cancel".
    	 */
    	public static const ItemNotFound:String = "item-not-found"; 
    	
    	/**
    	 * the sending entity has provided or communicated an XMPP address (e.g., a value of the 'to' attribute) or aspect thereof (e.g., a resource identifier) that does not adhere to the syntax defined in Addressing SchemeAddressing Scheme; the associated error type SHOULD be "modify".
    	 */
    	public static const JidMalformed:String = "jid-malformed"; 
    		
    	/**
    	 * the recipient or server understands the request but is refusing to process it because it does not meet criteria defined by the recipient or server (e.g., a local policy regarding acceptable words in messages); the associated error type SHOULD be "modify".
    	 */
    	public static const NotAcceptable:String = "not-acceptable"; 
    	
    	/**
    	 * the recipient or server does not allow any entity to perform the action; the associated error type SHOULD be "cancel".
    	 */
    	public static const NotAllowed:String = "not-allowed"; 
    	
    	/**
    	 * the sender must provide proper credentials before being allowed to perform the action, or has provided improper credentials; the associated error type SHOULD be "auth".
    	 */
    	public static const NotAuthorized:String = "not-authorized"; 
    	
    	/**
    	 * the requesting entity is not authorized to access the requested service because payment is required; the associated error type SHOULD be "auth".
    	 */
    	public static const PaymentRequired:String = "payment-required"; 
    	
    	/**
    	 * the intended recipient is temporarily unavailable; the associated error type SHOULD be "wait" (note: an application MUST NOT return this error if doing so would provide information about the intended recipient's network availability to an entity that is not authorized to know such information).
    	 */
    	public static const RecipientUnavaible:String = "recipient-unavailable"; 
    	
    	/**
    	 * the recipient or server is redirecting requests for this information to another entity, usually temporarily (the error stanza SHOULD contain the alternate address, which MUST be a valid JID, in the XML character data of the <redirect/> element); the associated error type SHOULD be "modify".
    	 */
    	public static const Redirect:String = "redirect"; 
    	
    	/**
    	 * the requesting entity is not authorized to access the requested service because registration is required; the associated error type SHOULD be "auth".
    	 */
    	public static const RegistrationRequired:String = "registration-required"; 
    	
    	/**
    	 * a remote server or service specified as part or all of the JID of the intended recipient does not exist; the associated error type SHOULD be "cancel".
    	 */
    	public static const RemoteServerNotFound:String = "remote-server-not-found"; 
    	
    	/**
    	 * a remote server or service specified as part or all of the JID of the intended recipient (or required to fulfill a request) could not be contacted within a reasonable amount of time; the associated error type SHOULD be "wait".
    	 */
    	public static const RemoteServerTimeOut:String = "remote-server-timeout"; 
    	
    	/**
    	 * the server or recipient lacks the system resources necessary to service the request; the associated error type SHOULD be "wait".
    	 */
    	public static const ResourceVarraint:String = "resource-varraint"; 
    	
    	/**
    	 * the server or recipient does not currently provide the requested service; the associated error type SHOULD be "cancel".
    	 */
    	public static const ServiceUnavailable:String = "service-unavailable"; 
    	
    	/**
    	 * the requesting entity is not authorized to access the requested service because a subscription is required; the associated error type SHOULD be "auth".
    	 */
    	public static const SubscriptionRequired:String = "subscription-required"; 
    	
    	/**
    	 * the error condition is not one of those defined by the other conditions in this list; any error type may be associated with this condition, and it SHOULD be used only in conjunction with an application-specific condition.
    	 */
    	public static const UndefinedCondition:String = "undefined-condition"; 
    	
    	/**
    	 * the recipient or server understood the request but was not expecting it at this time (e.g., the request was out of order); the associated error type SHOULD be "wait".
    	 */
    	public static const UnexpectedRequest:String = "unexpected-request";
    	
    	public static const values:Array = new Array(BadRequest,
    																		Conflict,
    																		FeatureNotImplemented,
    																		Forbidden,
    																		Gone,
    																		InternalServerError,
    																		ItemNotFound,
    																		JidMalformed,
    																		NotAcceptable,
    																		NotAllowed,
    																		NotAuthorized,
    																		PaymentRequired,
    																		RecipientUnavaible,
    																		Redirect,
    																		RegistrationRequired,
    																		RemoteServerNotFound,
    																		RemoteServerTimeOut,
    																		ResourceVarraint,
    																		ServiceUnavailable,
    																		SubscriptionRequired,
    																		UndefinedCondition,
    																		UnexpectedRequest);
    																		
    	public static function isCondition(condition:String):Boolean 
		{
			var n:int = values.length;
			
			for (var i:int=0; i < n; i++)
			{
				if (condition == values[i])
					return true;
			}
			
			return false;
        }
	}
}