package com.muzari.polskabot.fade
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import com.sociodox.utils.Base64;
	
	/**
	 * Client represents single instance that uses encoding.
	 * @author Wiktor Tkaczyński
	 */
	public class Client extends EventDispatcher
	{
		
		private var _pandora:Pandora = new Pandora();
		
		public function Client()
		{
		
		}
		
		public function reset():void
		{
			_pandora = new Pandora();
		}
		
		public function initStageOne(code:String):void
		{
			_pandora.initStageOne(Base64.decode(code));
			
			_pandora.getStageOne().addEventListener(Event.ACTIVATE, function(e:Event):void
			{
				dispatchEvent(new Event(Event.ACTIVATE));
			});
			
			_pandora.getStageOne().addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
			{
				dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
			});
		
		}
		
		public function generateKey():String
		{
			return Base64.encode(_pandora.generateObfuscationCallback());
		}
		
		public function initStageTwo(code:String):void
		{
			_pandora.initStageTwo(Base64.decode(code));
		}
		
		public function encode(input:String):String
		{
			return Base64.encode(_pandora.encode(Base64.decode(input)));
		}
		
		public function decode(input:String):String
		{
			return Base64.encode(_pandora.decode(Base64.decode(input)));
		}
	
	}

}