package com.muzari.polskabot.fade
{
	import flash.events.Event;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	
	public class Wrapper extends EventDispatcher
	{
		protected var _activated:Boolean;
		
		public var _encoder:Object;
		
		public function Wrapper()
		{
		
		}
		
		public final function load(code:ByteArray):void
		{
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
			
			loaderInfo.addEventListener(Event.COMPLETE, handleError);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleSuccess);
			
			loaderContext.allowLoadBytesCodeExecution = true;
			loader.loadBytes(code, loaderContext);
		}
		
		private final function handleSuccess(e:Event = null):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			
			loaderInfo.removeEventListener(Event.COMPLETE, handleSuccess);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
			
			this._encoder = loaderInfo.content;
			this.activate();
			dispatchEvent(new Event(Event.ACTIVATE));
		}
		
		private final function handleError(e:IOErrorEvent):void
		{
			trace("Stage one wasn't initialized successfuly");
		}
		
		public function decode(buffer:ByteArray):ByteArray
		{
			if (_activated)
			{
				return _encoder.decode(buffer);
			}
			return buffer;
		}
		
		public function encode(buffer:ByteArray):ByteArray
		{
			if (_activated)
			{
				return _encoder.encode(buffer);
			}
			return buffer;
		}
		
		private function activate():void
		{
			_activated = true;
		}
	
	}

}