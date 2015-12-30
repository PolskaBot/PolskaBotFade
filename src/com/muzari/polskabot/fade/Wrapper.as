package com.muzari.polskabot.fade
{
	import flash.system.SecurityDomain;
	import flash.system.ApplicationDomain;
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
		
		public final function load(param1:ByteArray):void
		{
			var _loc1_:Loader = new Loader();
			var _loc2_:LoaderInfo = _loc1_.contentLoaderInfo;
			_loc2_.addEventListener(Event.COMPLETE, this.handleAlgorithmLoadFinished);
			_loc2_.addEventListener(IOErrorEvent.IO_ERROR, this.handleAlgorithmLoadIoError);
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.allowCodeImport = true;
			_loc1_.loadBytes(param1, loaderContext);
		}
		
		private final function handleAlgorithmLoadFinished(param1:Event = null):void
		{
			var _loc2_:LoaderInfo = param1.target as LoaderInfo;
			_loc2_.removeEventListener(Event.COMPLETE, this.handleAlgorithmLoadFinished);
			_loc2_.removeEventListener(IOErrorEvent.IO_ERROR, this.handleAlgorithmLoadIoError);
			this._encoder = _loc2_.content;
			this.activate();
			dispatchEvent(new Event(Event.ACTIVATE));
		}
		
		private final function handleAlgorithmLoadIoError(param1:IOErrorEvent):void
		{
			trace("Erorr while working on stageOne");
		}
		
		public function decode(param1:ByteArray):ByteArray
		{
			if (this.isActivated())
			{
				return this._encoder.decode(param1);
			}
			return param1;
		}
		
		public function encode(param1:ByteArray):ByteArray
		{
			if (this._activated)
			{
				return this._encoder.encode(param1);
			}
			return param1;
		}
		
		public function activate():void
		{
			this._activated = true;
		}
		
		public function deactivate():void
		{
			this._activated = false;
		}
		
		public function isActivated():Boolean
		{
			return this._activated;
		}
	
	}

}