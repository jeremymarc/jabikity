package com.unikity.jabikity.protocol.core.sasl
{
	public class SASLFailureCondition
	{
		public static const Aborted:String = "aborted";
		public static const IncorrectEncoding:String = "incorrect-encoding";
		public static const InvalidAuthZid:String = "invalid-authzid";
		public static const InvalidMechanism:String = "invalid-mechanism";
		public static const MechanismTooWeak:String = "mechanism-too-weak";
		public static const NotAuthorized:String = "not-authorized";
		public static const NoMechanism:String = "no-mechanism";
		public static const TemporyAuthFailure:String = "temporary-auth-failure";
		public static const BadProtocol:String = "bad-protocol";
		
		public static const values:Array = new Array(Aborted, IncorrectEncoding, InvalidAuthZid, InvalidMechanism, MechanismTooWeak, NotAuthorized, NoMechanism, TemporyAuthFailure, BadProtocol);
		
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