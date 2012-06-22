package com.unikity.jabikity.authenticator
{
	import com.hurlant.util.Base64;
	import com.unikity.jabikity.protocol.core.sasl.SASLMechanismType;
		
	public class SASLPlainAuthenticator extends SASLAuthenticator
	{
		public static const MECHANISM:String = SASLMechanismType.Plain;
		
		public function SASLPlainAuthenticator(username:String=null, password:String=null)
		{
			super(MECHANISM, username, password);
		}
		
		override protected function getAuthenticationContent():String
		{
			var authContent:String = '\u0000' + username + '\u0000' + password;
			return Base64.encode(authContent);
		}
	}
}