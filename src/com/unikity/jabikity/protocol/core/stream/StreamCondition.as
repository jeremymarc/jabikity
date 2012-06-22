package com.unikity.jabikity.protocol.core.stream
{
	public class StreamCondition
	{
		/**
    	 * the entity has sent XML that cannot be processed
    	 */
    	public static const BadFormat:String = "bad-format";
    	
    	/**
    	 * the entity has sent a namespace prefix that is unsupported, 
    	 * or has sent no namespace prefix on an element that requires such a prefix
    	 */
    	public static const BadNamespacePrefix:String = "bad-namespace-prefix";
    	
    	/**
    	 * the server is closing the active stream for this
    	 * entity because a new stream has been initiated that conflicts with
    	 * the existing stream.
    	 */
    	public static const Conflict:String = "conflict";
    	
    	/**
    	 * the entity has not generated any traffic over the stream for some period of time
    	 */
    	public static const ConnectionTimeout:String = "connection-timeout";
    	
    	/**
    	 * the value of the 'to' attribute provided by the initiating entity in the stream 
    	 * header corresponds to a hostname that is no longer hosted by the server.
    	 */
    	public static const HostGone:String = "host-gone";
    	
    	/**
    	 * the value of the 'to' attribute provided by the initiating entity in the stream
    	 * header does not correspond to a hostname that is hosted by the server.
    	 */
    	public static const HostUnknown:String = "host-unknown";
    	
    	/**
    	 * a stanza sent between two servers lacks a 'to' or 'from' attribute (or the attribute has no value).
    	 */
    	public static const ImproperAddressing:String = "improper-addressing";
    	
    	/**
    	 * the server has experienced a  misconfiguration or an otherwise-undefined internal error that
    	 * prevents it from servicing the stream.
    	 */
    	public static const InternalServerError:String = "internal-server-error";
    	
    	/**
    	 * the JID or hostname provided in a 'from' address does not match an authorized JID or validated domain
    	 * negotiated between servers via SASL or dialback, or between a
    	 * client and a server via authentication and resource binding.
    	 */
    	public static const InvalidFrom:String = "invalid-from";
    	
    	/**
    	 * the stream ID or dialback ID is invalid or does not match an ID previously provided.
    	 */
    	public static const InvalidId:String = "invalid-id";
    	
    	/**
    	 * the entity has sent invalid XML over the stream to a server that performs validation
    	 */
    	public static const InvalidXml:String = "invalid-xml";
    	
    	/**
    	 * the entity has attempted to send data before the stream has been authenticated, or 
    	 * otherwise is not authorized to perform an action related to stream negotiation; the 
    	 * receiving entity MUST NOT process the offending stanza before sending the stream error.
    	 */
    	public static const NotAuthorized:String = "not-authorized";
    	
    	/**
    	 * the entity has violated some local service policy; the server MAY choose to specify the 
    	 * policy in the <text/> element or an application-specific condition element.
    	 */
    	public static const PolicyViolation:String = "policy-violation";
    	
    	/**
    	 * the server is unable to properly connect to a remote entity that is required for 
    	 * authentication or authorization.
    	 */
    	public static const RemoteConnectionFailed:String = "remote-connection-failed";
    	
    	/**
    	 * the server lacks the system resources necessary to service the stream.
    	 */
    	public static const ResourceConstraint:String = "resource-constraint";
    	
    	/**
    	 * the entity has attempted to send restricted XML features such as a comment, 
    	 * processing instruction, DTD, entity reference, or unescaped character
    	 */
    	public static const RestrictedXml:String = "restricted-xml";
    	
    	/**
    	 * the server will not provide service to the initiating entity but is redirecting
    	 * traffic to another host; the server SHOULD specify the alternate hostname or IP
    	 * address (which MUST be a valid domain identifier) as the XML character data of
    	 * the <see-other-host/> element.
    	 */
    	public static const SeeOtherHost:String = "see-other-host";
    	
    	/**
    	 * the server is being shut down and all active streams are being closed.
    	 */
    	public static const SystemShutdown:String = "system-shutdown";
    	
    	/**
    	 * the error condition is not one of those defined by the other conditions in this 
    	 * list; this error condition SHOULD be used only in conjunction with an application-specific
    	 * condition.
    	 */
    	public static const UndefinedCondition:String = "undefined-condition";
    	
    	/**
    	 * the initiating entity has encoded the stream in an encoding that is not supported by the 
    	 * server.
    	 */
    	public static const UnsupportedEncoding:String = "unsupported-encoding";
    	
    	/**
    	 * the initiating entity has sent a first-level child of the stream that is not supported 
    	 * by the server.
    	 */
    	public static const UnsupportedStanzaType:String = "unsupported-stanza-type";
    	
    	/**
    	 * the value of the 'version' attribute provided by the initiating entity in the stream header 
    	 * specifies a version of XMPP that is not supported by the server; the server MAY specify the 
    	 * version(s) it supports in the <text/> element.
    	 */
    	public static const UnsupportedVersion:String = "unsupported-version";
    	
    	/**
    	 * the initiating entity has sent XML that is not well-formed as defined by [XML].
    	 */
    	public static const XmlNotWellFormed:String = "xml-not-well-formed";
    	
		public static const values:Array = new Array(BadFormat, 
																			BadNamespacePrefix,
																			Conflict,
																			ConnectionTimeout,
																			HostGone,
																			HostUnknown,
																			ImproperAddressing,
																			InternalServerError,
																			InvalidFrom,
																			InvalidId,
																			InvalidXml,
																			NotAuthorized,
																			PolicyViolation,
																			RemoteConnectionFailed,
																			ResourceConstraint,
																			RestrictedXml,
																			SeeOtherHost,
																			SystemShutdown,
																			UndefinedCondition,
																			UnsupportedEncoding,
																			UnsupportedStanzaType,
																			UnsupportedVersion,
																			XmlNotWellFormed);
		
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