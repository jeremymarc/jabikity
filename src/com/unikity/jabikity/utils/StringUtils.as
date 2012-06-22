package com.unikity.jabikity.utils
{
	public class StringUtils
	{
		/**
		 * Make string safe for insert in XML.
		 *
		 * @param text	text to modify
		 * @return modified string
		 */
		public static function escape(text:String):String
		{
			var result:String = text.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&apos;").replace("<", "&lt;").replace(">", "&gt;");
			return result;
		}
		
		/**
		 * Change XML-safe chars for normal characters.
		 *
		 * @param text	text to modify
		 * @return modified String
		 */
		public static function unescape(text:String):String 
		{
			var result:String = text.replace("&quot;", "\"").replace("&apos;", "'").replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&");
			return result;
		}
		
		/**
		*	Replaces all instances of the replace string in the input string
		*	with the replaceWith string.
		* 
		*	@param input The string that instances of replace string will be 
		*	replaces with removeWith string.
		*
		*	@param replace The string that will be replaced by instances of 
		*	the replaceWith string.
		*
		*	@param replaceWith The string that will replace instances of replace
		*	string.
		*
		*	@returns A new String with the replace string replaced with the 
		*	replaceWith string.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			var sb:String = new String();
			var found:Boolean = false;

			var sLen:uint = input.length;
			var rLen:uint = replace.length;

			for (var i:uint = 0; i < sLen; i++)
			{
				if(input.charAt(i) == replace.charAt(0))
				{   
					found = true;
					for (var j:uint = 0; j < rLen; j++)
					{
						if (!(input.charAt(i + j) == replace.charAt(j)))
						{
							found = false;
							break;
						}
					}

					if (found)
					{
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			
			//TODO : if the string is not found, should we return the original string?
			return sb;
		}
		
		public static function getLastWord(str:String):String
		{
			if (str.substr(str.length - 1, 1) == " ")
				return null;
				
			var arr:Array = str.split(" ");
			if (arr.length > 0)
				return arr[arr.length-1];
				
			return null;
		}
		
		public static function firstToUpper(str:String):String
		{
			var firstLetter:String = str.substring(1, 0);
			var restOfWord:String = str.substring(1);
			return (firstLetter.toUpperCase() + restOfWord.toLowerCase());
		}
		
		public static function undiacritic(str:String):String
		{
			str = str.replace(/[áãàâäå]/g, "a");
			str = str.replace(/[éèêë]/g, "e");
			str = str.replace(/[íìîï]/g, "i");
			str = str.replace(/[ñ]/g, "n");
			str = str.replace(/[óõòôö]/g, "o");
			str = str.replace(/[úùûüµ]/g, "u");
			str = str.replace(/[ç]/g, "c");
			str = str.replace(/[ýÿ]/g, "y");
			str = str.replace(/[ÀÁÂÃÄÅ]/g, "A");
			str = str.replace(/[ÈÉÊË]/g, "E");
			str = str.replace(/[ÌÍÎÏ]/g, "I");
			str = str.replace(/[Ñ]/g, "N");
			str = str.replace(/[ÓÔÕÖÒ]/g, "O");
			str = str.replace(/[ÙÚÛÜ]/g, "U");
			str = str.replace(/[Ç]/g, "C");
			str = str.replace(/[Ý]/g, "Y");
			return str;
		}
	}
}