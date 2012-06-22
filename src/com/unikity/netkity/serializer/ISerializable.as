package com.unikity.netkity.serializer
{
	public interface ISerializable
	{
		function serialize():Object;
		function deserialize(object:Object):void;
	}
}