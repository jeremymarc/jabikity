package com.unikity.netkity
{
	public class ConnectionError extends Error
	{
		public var data:*;
		
		public function ConnectionError(message:String, data:*=null)
		{
			super(message);
			this.data = data;
		}
	}
}