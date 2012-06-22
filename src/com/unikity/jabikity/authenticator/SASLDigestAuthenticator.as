package com.unikity.jabikity.authenticator
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import com.unikity.jabikity.protocol.core.sasl.SASLMechanismType;
	import com.unikity.jabikity.utils.RandomUtil;
	
	import flash.utils.ByteArray;
	
	public class SASLDigestAuthenticator extends SASLAuthenticator
	{
		public static const MECHANISM:String = SASLMechanismType.DigestMD5;
		
		private var _realm:String = "";
		private var _nonce:String = "";
		private var _cnonce:String = "";
		private var _qop:String = "auth";
		private var _stale:String = "";
		private var _maxbuf:int;
		private var _charset:String = "";
		private var _algorithm:String = "";
		private var _cipher:String = "";
		private var _nc:String = "00000001";
		private var _rspauth:String;
		private var _finalChallenge:Boolean;
		private var _md5:MD5;
		
		private var _host:String;

		public function SASLDigestAuthenticator(username:String=null, password:String=null)
		{
			super(MECHANISM, username, password);
			
			_md5 = Crypto.getHash("md5") as MD5;
		}
				
		override protected function getChallengeResponse(challenge:String, host:String):String
		{
			decodeChallenge(challenge);
			
			if (_finalChallenge)
				return null;
				
			_host = host;
			_cnonce = md5hex(RandomUtil.string(16));
			
			return createResponseChallenge();
		}
		
		private function decodeChallenge(challenge:String):void
		{
			var decodedChallenge:String = Base64.decode(challenge);
			
			var realm:Array = decodedChallenge.match(/realm="([^,]*)"/i);
			if (realm && realm.length >= 1) _realm = realm[1];
			
			var nonce:Array = decodedChallenge.match(/nonce="([^,]*)"/i);
			if (nonce && nonce.length >= 1) _nonce = nonce[1];
								
			var stale:Array = decodedChallenge.match(/stale=([^,]*)/i);
			if (stale && stale.length >= 1) _stale = stale[1];
			
			var maxbuf:Array = decodedChallenge.match(/maxbuf=([^,]*)/i);
			if (maxbuf && maxbuf.length >= 1) _maxbuf = maxbuf[1];
			
			var charset:Array = decodedChallenge.match(/charset=([^,]*)/i);
			if (charset && charset.length >= 1) _charset = charset[1];
			
			var algorithm:Array = decodedChallenge.match(/algorithm=([^,]*)/i);
			if (algorithm && algorithm.length >= 1) _algorithm = algorithm[1];
			
			var cipher:Array = decodedChallenge.match(/cipher="([^"]*)"/i);
			if (cipher && cipher.length >= 1) _cipher = cipher[1];
			
			var rspauth:Array = decodedChallenge.match(/rspauth=([^,]*)/i);
			if (rspauth && rspauth.length >= 1) {
				_rspauth = rspauth[1];
				_finalChallenge = true;
			}
			
			/*var qop:Array = decodedChallenge.match(/qop="([^"]*)"/i);
			if (qop == null || qop.length < 1) // for handling value without comma
				qop = decodedChallenge.match(/qop=([^"]*)/i);
			if (qop && qop.length >= 1) _qop = qop[1];*/
		}
		
		private function createResponseChallenge():String
		{
			var challenge:String = "username=\"" + username + "\"";
			challenge += ",realm=\"" + _realm + "\"";
			challenge += ",nonce=\"" + _nonce + "\"";
			challenge += ",cnonce=\"" + _cnonce + "\"";			
			challenge += ",nc=" + _nc;
			challenge += ",qop=" + _qop;
			challenge += ",digest-uri=\"xmpp/" + _host + "\"";
			if (_charset) challenge += ",charset=" + _charset;
			
			challenge += ",response=" + computeDigestResponse();
	
			return Base64.encode(challenge);
		}
		
		private function computeDigestResponse():String
		{
			// Parameters
			var digestUri:String = "xmpp/" + _host;

			// Compute A1
			var digest:ByteArray = md5bytes(username + ":" + _realm + ":" + password);
			digest.writeUTFBytes(":" + _nonce + ":" + _cnonce);
			digest = _md5.hash(digest);
			var a1:String = Hex.fromArray(digest);

			// Compute A2
			var a2:String = md5hex("AUTHENTICATE:" + digestUri);
			
			// Compute reponse
			var response:String = md5hex(a1 + ":" + _nonce + ":" + _nc + ":" + _cnonce + ":" + _qop + ":" + a2);
			
			return response;
		}
		
		private function md5bytes(value:String):ByteArray
		{
			return _md5.hash(Hex.toArray(Hex.fromString(value)));
		}
		
		private function md5hex(value:String):String
		{
			return Hex.fromArray(_md5.hash(Hex.toArray(Hex.fromString(value))));
		}
	}
}