package com.unikity.jabikityx.protocol.vcard
{
	import com.unikity.jabikity.protocol.IXmppChunk;
	import com.unikity.jabikity.protocol.XmppChunk;
	import com.unikity.jabikity.utils.DateUtil;
	
	public class VCard extends XmppChunk implements IXmppChunk
	{
		public static const ELEMENT:String = "vCard";
		public static const NS:Namespace = new Namespace("", "vcard-temp");
		
		// Unique identifier property.
		public var uid:String;				// <UID></UID>

		// Formatted or display name property.
		public var formattedName:String;		// <FN>Peter Saint-Andre</FN>

		// Structured name property. 
		// Name components with multiple values must be specified as a comma separated list of values.
		public var familyName:String;		// <N><FAMILY>Saint-Andre</FAMILY></N>
		public var givenName:String;			// <N><GIVEN>Peter</GIVEN></N>
		public var middleName:String;		// <N><MIDDLE/></N>
		public var namePrefix:String;		// <N><PREFIX/></N>
		public var nameSuffix:String;		// <N><SUFFIX/></N>
		
		// Nickname property. Multiple nicknames must be specified as a comma separated list value.
		public var nickname:String; 			// <NICKNAME>stpeter</NICKNAME>

		// Photograph property. Value is either a BASE64 encoded binary value or a URI to the external content.
		public var photo:String;				// <PHOTO>URI to the external content</PHOTO> or <PHOTO>BASE64 encoded binary value</PHOTO>
		
		public var photoType:String;
		public var photoBinVal:String;
		
		// Birthday property. Value must be an ISO 8601 formatted date or date/time value.
		public var birthday:Date;			// <BDAY>1966-08-06</BDAY>
		
		// Time zone's Standard Time UTC offset. Value must be an ISO 8601 formatted UTC offset.
		public var timezone:Date;			// <TZ></TZ>

		// Organizational name and units property.
		public var organisationName:String;	// <ORG><ORGNAME>XMPP Standards Foundation</ORGNAME></ORG>
		public var organisationUnit:String;	// <ORG><ORGUNIT/>/ORG>
		
		// Organization logo property.
		public var organisationLogo:String;	// <LOGO>URI to the external content</PHOTO> or <PHOTO>BASE64 encoded binary value</LOGO>

		// Title property.
		public var title:String;				// <TITLE>Executive Director</TITLE>

		// Role property.
		public var role:String;				// <ROLE>Patron Saint</ROLE>

		// NOTE: the following element was added by the Jabber project (now XMPP Standards Foundation) to
        // handle Jabber IDs; the value must be in the form of user@host
		public var jabberId:String;			// <JABBERID>stpeter@jabber.org</JABBERID>

		// Directory URL property.
		public var url:String;				// <URL>http://www.xmpp.org/xsf/people/stpeter.shtml</URL>

		// NOTE: the following element was added by the Jabber project (now XMPP Standards Foundation) to
        // handle free-form descriptive text.
		public var description:String;		// <DESC>description</DESC>

		// Commentary note property.
		public var comment:String;			// <NOTE>comment</NOTE>

		// TODO: add address, phone, email, categories, key, mailer, geo, agent, prodid, rev, sort-string, sound, class field
				
		public function VCard()
		{
			super(ELEMENT, NS);
		}
		
		override public function deserialize(object:Object):void
		{
			super.deserialize(object);
			
			var xml:XML = object as XML;

			if (xml.ns::UID.length() > 0) uid = xml.ns::UID;
			if (xml.ns::FN.length() > 0) formattedName = xml.ns::FN;
			if (xml.ns::NICKNAME.length() > 0) nickname = xml.ns::NICKNAME;
			if (xml.ns::PHOTO.length() > 0) {
				for each (var child:XML in xml.ns::PHOTO.children())
				{
					switch(child.name().localName)
					{
						case "TYPE":
							this.photoType = child.valueOf().toString();
							break;
						case "BINVAL":
							this.photoBinVal = child.valueOf().toString();
							break;
					}
				}
				
				/*if (xml.ns::PHOTO.TYPE.length() == 0 && xml.ns::PHOTO.BINVAL.length() == 0) {
					photo = xml.ns::PHOTO;
				}*/
			} 
			if (xml.ns::BDAY.length() > 0) birthday = DateUtil.toDate(xml.ns::BDAY);
			if (xml.ns::TZ.length() > 0) timezone = DateUtil.toISO8601Date(xml.ns::TZ);
			if (xml.ns::JABBERID.length() > 0) jabberId = xml.ns::JABBERID;
			if (xml.ns::DESC.length() > 0) description = xml.ns::DESC;
			if (xml.ns::NOTE.length() > 0) comment = xml.ns::NOTE;
			if (xml.ns::LOGO.length() > 0) organisationLogo = xml.ns::LOGO;
			if (xml.ns::TITLE.length() > 0) title = xml.ns::TITLE;
			if (xml.ns::ROLE.length() > 0) role = xml.ns::ROLE;
			if (xml.ns::URL.length()  > 0) url = xml.ns::URL;

			if (xml.ns::N.FAMILY.length() > 0) familyName = xml.ns::N.FAMILY;
			if (xml.ns::N.GIVEN.length()  > 0) givenName = xml.ns::N.GIVEN;
			if (xml.ns::N.MIDDLE.length() > 0) middleName = xml.ns::N.MIDDLE;
			if (xml.ns::N.PREFIX.length() > 0) namePrefix = xml.ns::N.PREFIX;
			if (xml.ns::N.SUFFIX.length() > 0) nameSuffix = xml.ns::N.SUFFIX;

			if (xml.ns::ORG.ORGNAME.length() > 0) organisationName = xml.ns::ORG.ORGNAME;
			if (xml.ns::ORG.ORGUNIT.length() > 0) organisationUnit = xml.ns::ORG.ORGUNIT;
		}
	
		override public function serialize():Object
		{
			var xml:XML = super.serialize() as XML;
			
			if (uid) xml.UID = uid;
			if (formattedName) xml.FN = formattedName;
			if (nickname) xml.NICKNAME = nickname;
			if (photo) xml.PHOTO = photo;
			if (birthday) xml.BDAY = DateUtil.toString(birthday);
			if (timezone) xml.TZ = DateUtil.toISO8601String(timezone);
			if (jabberId) xml.JABBERID = jabberId;
			if (url) xml.URL = url;
			if (description) xml.DESC = description;
			if (comment) xml.NOTE = comment;
			if (organisationLogo) xml.LOGO = organisationLogo;
			if (title) xml.TITLE = title;
			if (role) xml.ROLE = role;

			if (familyName) xml.N.FAMILY = familyName;
			if (givenName) 	xml.N.GIVEN = givenName;
			if (middleName) xml.N.MIDDLE = middleName;
			if (namePrefix) xml.N.PREFIX = namePrefix;
			if (nameSuffix) xml.N.SUFFIX = nameSuffix;
			
			if (organisationName) xml.ORG.ORGNAME = organisationName;
			if (organisationUnit) xml.ORG.ORGUNIT = organisationUnit;

			return xml;
		}
	}
}