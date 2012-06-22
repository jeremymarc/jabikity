package com.unikity.jabikity.authenticator
{
	import com.unikity.jabikity.XmppConnection;
	import com.unikity.jabikity.protocol.core.sasl.*;
	import com.unikity.jabikity.protocol.core.stream.*;
	import com.unikity.netkity.authenticator.*;
	import com.unikity.netkity.serializer.ISerializable;

	public class SASLAuthenticator extends Authenticator
	{
		public var mechanism:String;
		public var username:String;
		public var password:String;
		
		protected var saslSuccessReceived:Boolean;
		
		public function SASLAuthenticator(mechanism:String, username:String=null, password:String=null)
		{
			super();

			this.username = username;
			this.password = password;
			this.mechanism = mechanism;
		}
		
		override public function authenticate():void
		{
			// Send the open xml element and the open connection stream
			connection.send("<?xml version='1.0' encoding='UTF-8'?>");
			var stream:Stream = new Stream(connection.host, "1.0");
			connection.send(stream);
		}
		
		override public function filter(object:ISerializable):Boolean
		{
			return object is Stream || object is SASLChallenge || object is SASLFailure || object is SASLSuccess;
		}
		
		override public function collect(object:ISerializable):void
		{
			if (authenticated)
				return;
				
			if (object is Stream)
			{
				connection.send(new SASLAuth(mechanism, getAuthenticationContent()));
			}
			else if (object is SASLChallenge)
			{
				var challenge:SASLChallenge = object as SASLChallenge;
				if (challenge.content)
				{
					var response:SASLResponse = new SASLResponse(getChallengeResponse(challenge.content, connection.host));
					connection.send(response);
				}
			}
			else if (object is SASLSuccess)
			{
				authenticationSuccess();						
			}
			else if (object is SASLFailure)
			{
				var failure:SASLFailure = object as SASLFailure;
				authenticationFail(failure);
			}
		}
		
		protected function getAuthenticationContent():String
		{
			return null;
		}
		
		protected function getChallengeResponse(challenge:String, host:String):String
		{
			return null;
		}
	}
}