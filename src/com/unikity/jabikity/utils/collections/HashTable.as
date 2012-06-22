package com.unikity.jabikity.utils.collections
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import mx.collections.ArrayCollection;
	
	public class HashTable extends Proxy implements IDictionary
	{
		private var _map:Dictionary;
		private var _count:uint;
		private var _keys:ArrayCollection;
		
		public function get keys():ArrayCollection { return _keys; }		
		public function get count():uint { return _count; }
		
		public function HashTable() 
		{
			_count = 0;
			_map = new Dictionary();
			_keys = new ArrayCollection();
		}
		
		flash_proxy override function getProperty(name:*):* 
		{
			return _map[name];
		}
		
		public function getValue(key:*):* 
		{
			return _map[key];
		}
		
		public function contains(key:*):Boolean 
		{
			return _map[key] != null;
		}
		
		public function add(key:*, value:*):void 
		{
			if (contains(key))
				throw new ArgumentError("Element already exist.");

			_keys.addItem(key);
			_map[key] = value;
			_count++;
		}
		
		public function remove(key:*):void 
		{
		    _keys.removeItemAt(_keys.getItemIndex(key));
			_map[key] = null;
			delete _map[key];
			_count--;
		}
	}
}