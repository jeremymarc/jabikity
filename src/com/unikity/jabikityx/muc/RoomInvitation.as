package com.unikity.jabikityx.muc
{
	import com.unikity.jabikity.protocol.core.Message;
	
	public class RoomInvitation
	{
		public var room:String;
		public var sender:String;
		public var reason:String;
		public var password:String;
		public var message:Message;
	}
}