package com.unikity.jabikity.authenticator
{
	import com.unikity.jabikity.protocol.core.sasl.SASLMechanismType;
	
	/*
            S: <stream:features>
                    <mechanisms xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>
                        <mechanism>DIGEST-MD5<mechanism>
                        <mechanism>ANONYMOUS<mechanism>
                    </mechanisms>
               </stream:features>
            
            * So, the proper exchange for this ANONYMOUS mechanism would be:

            C: <auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' mechanism='ANONYMOUS'/>
            S: <success xmlns='urn:ietf:params:xml:ns:xmpp-sasl'/>

            or, in case of the optional trace information:

            C: <auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' mechanism='ANONYMOUS'>
                    c2lyaGM=
               </auth>
            S: <success xmlns='urn:ietf:params:xml:ns:xmpp-sasl'/>

	*/
	public class SASLAnonymousAuthenticator extends SASLAuthenticator
	{
		public static const MECHANISM:String = SASLMechanismType.Anonymous;
		
		public function SASLAnonymousAuthenticator()
		{
			super(MECHANISM, username, password);
		}
	}
}