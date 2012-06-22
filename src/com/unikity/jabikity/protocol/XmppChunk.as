package com.unikity.jabikity.protocol
{
	import flash.utils.getQualifiedClassName;
	
	public class XmppChunk implements IXmppChunk
	{
		private var xmppChunkFactory:XmppChunkFactory = XmppChunkFactory.getInstance();
		
		private var _elementName:String;
		private var _ns:Namespace;
		private var _chunks:Array;
		
		public function get elementName():String { return _elementName; }
		public function set elementName(elementName:String):void { _elementName = elementName; }
		
		public function get ns():Namespace { return _ns; }
		public function set ns(ns:Namespace):void { _ns = ns; }
		
		public function get chunks():Array { return _chunks; }
		
		public function XmppChunk(elementName:String, ns:Namespace=null)
		{
			this.elementName = elementName;
			this.ns = ns;
			
			_chunks = new Array();
		}
		
		public function getChunk(chunkClass:Class):IXmppChunk
		{
			var chunkClassName:String = getQualifiedClassName(chunkClass);			
			return _chunks[chunkClassName];
		}
		
		public function hasChunk(chunkClass:Class):Boolean
		{
			return getChunk(chunkClass) != null;
		}		

		public function addChunk(chunk:IXmppChunk):void
		{
			var chunkClassName:String = getQualifiedClassName(chunk);			
			_chunks[chunkClassName] = chunk;
 		}
 		
 		public function removeChunk(chunk:IXmppChunk):void
		{
			var chunkClassName:String = getQualifiedClassName(chunk);			
			if (_chunks[chunkClassName] != null)
				delete _chunks[chunkClassName];
 		}

		public function deserialize(object:Object):void
		{
			var xml:XML = object as XML;
			elementName = xml.namespace() ? xml.name().localName : xml.name();
			ns = xml.namespace();
			
			// Deserialize childs
			for each (var child:XML in xml.children())
		    {
		    	var childName:String = child.namespace() ? child.name().localName : child.name();
		    	var childNs:Namespace = child.namespace();
		    	if (childName != null) 
		    	{
		    		var chunk:IXmppChunk = xmppChunkFactory.retrieveXmppChunk(childName, childNs);
		    		if (chunk != null)
		    		{
		    			chunk.deserialize(child);
		    			addChunk(chunk);
		    		}
		    	}
			}
		}
		  		
 		public function serialize():Object
		{
			var xml:XML = <{elementName}/>;
			
			if (ns != null)
				xml.setNamespace(ns);
			
			// Serialize & add childs
			for each (var packet:IXmppChunk in _chunks)
			{
				var xmlPacket:XML = packet.serialize() as XML;
				xml.appendChild(xmlPacket);
			}

			return xml;
		}
	}
}