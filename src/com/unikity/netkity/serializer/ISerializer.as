package com.unikity.netkity.serializer
{
	public interface ISerializer
	{
		function serialize(data:String):ISerializable;
		
		function deserialize(object:ISerializable):String;
	}
}