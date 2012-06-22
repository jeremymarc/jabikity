package com.unikity.jabikity.utils
{
	/**
	 * Utility class provides common random functions.
	 */
	public class RandomUtil 
	{
		private static const numbersAndLetters:String = 
			"0123456789abcdefghijklmnopqrstuvwxyz" +
			"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    							  		
		public function RandomUtil():void
		{			
		}
		
		/**
		 * returns a number between 0-1 exclusive.
		 */
		public static function random():Number 
		{
			return Math.random();
		}
		
		/**
		 * float(50); // returns a number between 0-50 exclusive
		 * float(20,50); // returns a number between 20-50 exclusive
		 */ 
		public static function float(min:Number, max:Number=NaN):Number 
		{
			if (isNaN(max)) {
				max = min; 
				min = 0;
			}
			return random() * (max - min) + min;
		}
		
		/**
		 * boolean(); // returns true or false (50% chance of true)
		 * boolean(0.8); // returns true or false (80% chance of true)
		 */
		public static function boolean(chance:Number=0.5):Boolean 
		{
			return (random() < chance);
		}
		
		/**
		 * sign(); // returns 1 or -1 (50% chance of 1)
		 * sign(0.8); // returns 1 or -1 (80% chance of 1)
		 */
		public static function sign(chance:Number=0.5):int
		{
			return (random() < chance) ? 1 : -1;
		}
		
		/** 
		 * bit(); // returns 1 or 0 (50% chance of 1)
		 * bit(0.8); // returns 1 or 0 (80% chance of 1)
		 */
		public static function bit(chance:Number=0.5):int 
		{
			return (random() < chance) ? 1 : 0;
		} 
		
		/**
		 * integer(50); // returns an integer between 0-49 inclusive
		 * integer(20,50); // returns an integer between 20-49 inclusive
		 */
		public static function integer(min:Number,max:Number=NaN):int 
		{
			if (isNaN(max)) { 
				max = min; 
				min=0; 
			}
			// Need to use floor instead of bit shift to work properly with negative values:
			return Math.floor(float(min, max));
		}
		
		public static function string(length:Number):String
		{
			if (length < 1)
            	return null;
            
            var result:String = new String();    
                   
            for (var i:uint=0; i < length; i++)
            	result += numbersAndLetters.charAt(RandomUtil.integer(0, 71));
            
			return result;
		}
	}
}