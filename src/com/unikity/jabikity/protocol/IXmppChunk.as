package com.unikity.jabikity.protocol
{
	import com.unikity.netkity.serializer.ISerializable;
	
	public interface IXmppChunk extends ISerializable
	{
		function get elementName():String;
		function set elementName(elementName:String):void;
		
		function get ns():Namespace;
		function set ns(ns:Namespace):void;
		
		function get chunks():Array;	
				
		function addChunk(chunk:IXmppChunk):void;
		function removeChunk(chunk:IXmppChunk):void;
		function getChunk(chunkClass:Class):IXmppChunk;
		function hasChunk(chunkClass:Class):Boolean;
	}
}