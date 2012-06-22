package com.unikity.jabikity.utils
{
	import mx.formatters.DateFormatter;
	
	public class DateUtil
	{
		private static var dateFormatter:DateFormatter = new DateFormatter();
		
		public static function toDate(dateString:String):Date
		{
			var datepattern:RegExp = /^(-?\d\d\d\d)-?(\d\d)-?(\d\d)/;
			var d:Array = dateString.match(datepattern);
						
			var newFormat:String = d[1] + "/" + d[2] + "/" + d[3];
			var date:Date = new Date(newFormat);
			
			return date;
		}
		
		public static function toString(date:Date):String
		{
			dateFormatter.formatString = "YYYY-MM-DD";
			var dateString:String = dateFormatter.format(date);
			return dateString;
		}
		
		public static function toISO8601String(date:Date):String
		{
			dateFormatter.formatString = "YYYY-MM-DDTHH:NN:SS";
			var dateString:String = dateFormatter.format(date);
			return dateString;
		}
		
		public static function toISO8601Date(dateString:String):Date
		{
			// ISO 8601 format: 'CCYYMMDDThh:mm:ss' ex: '20020910T23:41:07'
			var datepattern:RegExp = /^(-?\d\d\d\d)-?(\d\d)-?(\d\d)T(\d\d):(\d\d):(\d\d)/;
			var d:Array = dateString.match(datepattern);
						
			var newFormat:String = d[1] + "/" + d[2] + "/" + d[3] + " " + d[4] + ":" + d[5] + ":" + d[6] + " GMT-0000";
			var date:Date = new Date(newFormat);
			
			return date;
		}
	}
}