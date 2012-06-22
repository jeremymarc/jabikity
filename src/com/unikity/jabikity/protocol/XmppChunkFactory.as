package com.unikity.jabikity.protocol
{
	import com.unikity.jabikity.protocol.core.*;
	import com.unikity.jabikity.protocol.core.bind.*;
	import com.unikity.jabikity.protocol.core.sasl.*;
	import com.unikity.jabikity.protocol.core.stream.*;
	import com.unikity.jabikity.protocol.core.tls.*;
	import com.unikity.jabikity.protocol.im.*;
	import com.unikity.jabikityx.protocol.*;
	import com.unikity.jabikityx.protocol.capabilities.*;
	import com.unikity.jabikityx.protocol.delayeddelivery.*;
	import com.unikity.jabikityx.protocol.discovery.*;
	import com.unikity.jabikityx.protocol.form.*;
	import com.unikity.jabikityx.protocol.muc.*;
	import com.unikity.jabikityx.protocol.nickname.Nickname;
	import com.unikity.jabikityx.protocol.ping.*;
	import com.unikity.jabikityx.protocol.privatestorage.*;
	import com.unikity.jabikityx.protocol.unikity.*;
	import com.unikity.jabikityx.protocol.vcard.*;
	import com.unikity.netkity.serializer.*;
	
	public class XmppChunkFactory
	{
		private static var _instance:XmppChunkFactory;
		
		protected var chunkMap:Array;

		public function XmppChunkFactory()
        {
            chunkMap = new Array();

            registerXmppChunks();
        }
        
        public static function getInstance():XmppChunkFactory
        {
        	if (_instance == null)
        		_instance = new XmppChunkFactory();
        	
        	return _instance;
        }
        
        private function registerXmppChunks():void
		{
			registerXmppChunk(Message.ELEMENT, null, Message);
			registerXmppChunk(IQ.ELEMENT, null, IQ);	
			registerXmppChunk(Presence.ELEMENT, null, Presence);
			
			/**
			 * RFC 3920: XML streams, http://www.xmpp.org/rfcs/rfc3920.html
			 */
			registerXmppChunk(Stream.ELEMENT, Stream.NS, Stream);
			registerXmppChunk(StreamError.ELEMENT, StreamError.NS, StreamError);
			registerXmppChunk(TLSStart.ELEMENT, TLSStart.NS, TLSStart);
			registerXmppChunk(TLSProceed.ELEMENT, TLSProceed.NS, TLSProceed);
			registerXmppChunk(TLSFailure.ELEMENT, TLSFailure.NS, TLSFailure);
			registerXmppChunk(SASLAuth.ELEMENT, SASLAuth.NS, SASLAuth);
			registerXmppChunk(SASLChallenge.ELEMENT, SASLChallenge.NS, SASLChallenge);
			registerXmppChunk(SASLResponse.ELEMENT, SASLResponse.NS, SASLResponse);
			registerXmppChunk(SASLAbort.ELEMENT, SASLAbort.NS, SASLAbort);
			registerXmppChunk(SASLSuccess.ELEMENT, SASLSuccess.NS, SASLSuccess);
			registerXmppChunk(SASLFailure.ELEMENT, SASLFailure.NS, SASLFailure);
			registerXmppChunk(Bind.ELEMENT, Bind.NS, Bind);
			
			/**
			 * RFC 3921: IM & PRESENCE, http://www.xmpp.org/rfcs/rfc3921.html
			 */
			registerXmppChunk(Session.ELEMENT, Session.NS, Session);
			
			/**
			 * XEP-0115: CAPABILITIES, http://www.xmpp.org/extensions/xep-0115.html
			 */
			registerXmppChunk(Capabilities.ELEMENT, Capabilities.NS, Capabilities);
			
			/**
			 * XEP-0030: SERVICE DISCOVERY, http://www.xmpp.org/extensions/xep-0030.html
			 */
			registerXmppChunk(DiscoveryInfo.ELEMENT, DiscoveryInfo.NS, DiscoveryInfo);
			registerXmppChunk(DiscoveryItems.ELEMENT, DiscoveryItems.NS, DiscoveryItems);
			
			/**
			 * XEP-0091: DELAYED DELIVERY, http://www.xmpp.org/extensions/xep-0091.html
			 */
			registerXmppChunk(Delayed.ELEMENT, Delayed.NS, Delayed);
			
			/**
			 * XEP-0004: Data Forms, http://www.xmpp.org/extensions/xep-0004.html
			 */
			registerXmppChunk(DataForm.ELEMENT, DataForm.NS, DataForm);
			
			/**
			 * XEP-0054: vcard-temp, http://www.xmpp.org/extensions/xep-0054.html
			 */
			registerXmppChunk(VCard.ELEMENT, VCard.NS, VCard);
			
			/**
			 * XEP-0045: Multi-User chat, http://www.xmpp.org/extensions/xep-0045.html
			 */
			registerXmppChunk(MUC.ELEMENT, MUC.NS, MUC);
			registerXmppChunk(MUCUnique.ELEMENT, MUCUnique.NS, MUCUnique);			
			registerXmppChunk(MUCOwner.ELEMENT, MUCOwner.NS, MUCOwner);
			registerXmppChunk(MUCAdmin.ELEMENT, MUCAdmin.NS,  MUCAdmin);			
			registerXmppChunk(MUCUser.ELEMENT, MUCUser.NS, MUCUser);
			
			/**
			 * XEP-0249: Direct MUC Invitations, http://www.xmpp.org/extensions/xep-0249.html
			 */
			registerXmppChunk(MUCDirectInvitation.ELEMENT, MUCDirectInvitation.NS, MUCDirectInvitation);
			
			/**
			 * XEP-0049: Private XML Storage, http://www.xmpp.org/extensions/xep-0049.html
			 */
			registerXmppChunk(PrivateStorage.ELEMENT, PrivateStorage.NS, PrivateStorage);
			
			/**
			 * XEP-0199: XMPP Ping, http://xmpp.org/extensions/xep-0199.html
			 */
			registerXmppChunk(Ping.ELEMENT, Ping.NS, Ping);
			
			/**
			 * XEP-0172: User Nickname, http://xmpp.org/extensions/xep-0172.html
			 */
			registerXmppChunk(Nickname.ELEMENT, Nickname.NS, Nickname);
			
			
			registerXmppChunk(Roster.ELEMENT, Roster.NS, Roster);
			
			/**
			 * Unikity Extension
			 */
			 registerXmppChunk(UnikityTransport.ELEMENT, UnikityTransport.NS, UnikityTransport);
		}
				
		public function registerXmppChunk(elementName:String, ns:Namespace, chunkClass:Class):void
		{
			var chunkId:String = generateChunkId(elementName, ns);
			chunkMap[chunkId] = chunkClass;
		}
		
		public function unregisterXmppChunk(elementName:String, ns:Namespace):void
		{
			var chunkId:String = generateChunkId(elementName, ns);	
			
			if (chunkMap[chunkId] != null)
				delete chunkMap[chunkId];
		}
		
		public function retrieveXmppChunk(elementName:String, ns:Namespace):IXmppChunk
		{
			var chunkId:String = generateChunkId(elementName, ns);
			
			var chunkClass:Class = chunkMap[chunkId];
			if (chunkClass)
				return new chunkClass();
			
			return null;
		}
				
		public function hasXmppChunk(elementName:String, ns:Namespace):Boolean
		{
			var chunkId:String = generateChunkId(elementName, ns);			
			return chunkMap[chunkId] != null;
		}
		
		private function generateChunkId(elementName:String, ns:Namespace):String
		{
			var result:String = "";
			
			if (ns && ns.uri) result += ns.uri + "::";
			result += elementName;
			
			return result;
		}		
	}
}