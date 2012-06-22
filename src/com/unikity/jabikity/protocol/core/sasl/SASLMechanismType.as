package com.unikity.jabikity.protocol.core.sasl
{
	public class SASLMechanismType
	{
		public static const Plain:String = "PLAIN";
		public static const CramMD5:String = "CRAM-MD5";
		public static const DigestMD5:String = "DIGEST-MD5";
		public static const Anonymous:String = "ANONYMOUS";
		public static const XGoogleToken:String = "X-GOOGLE-TOKEN";
		public static const KerberosV4:String = "KERBEROS_V4";
		public static const GssAPI:String = "GSSAPI";
		
        public static const values:Array = new Array(Plain, CramMD5, DigestMD5, Anonymous, XGoogleToken, KerberosV4, GssAPI);
	}
}