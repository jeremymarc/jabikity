package com.unikity.jabikity.authenticator
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import com.unikity.jabikity.protocol.core.sasl.SASLMechanismType;
	
	import flash.utils.ByteArray;
	
	public class SASLCramMD5Authenticator extends SASLAuthenticator
	{
		public static const MECHANISM:String = SASLMechanismType.CramMD5;
		
		private var hmac:HMAC;
		
		public function SASLCramMD5Authenticator(username:String=null, password:String=null)
		{
			super(MECHANISM, username, password);
			
			hmac = Crypto.getHMAC("md5") as HMAC;
		}
				
		override protected function getChallengeResponse(challenge:String, host:String):String
		{
			var decodedChallenge:String = Base64.decode(challenge);
			
			var digest:ByteArray  = hmac.compute(Hex.toArray(Hex.fromString(password)), Hex.toArray(Hex.fromString(decodedChallenge)));	
			
			return Base64.encode(username + ' ' + Hex.fromArray(digest));
		}
	}
}