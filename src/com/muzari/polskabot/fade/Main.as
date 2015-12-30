package com.muzari.polskabot.fade
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;
	
	/**
	 * Main is Fade entry point. It setups ExternalInterface to allow communication between both parties.
	 * @author Wiktor Tkaczyński
	 */
	public class Main extends Sprite
	{
		
		private var readyTimer:Timer;
		
		private var clients:Object = new Object();
		
		public function Main()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (ExternalInterface.available)
			{
				readyTimer = new Timer(100);
				readyTimer.addEventListener(TimerEvent.TIMER, checkStatus);
				readyTimer.start();
			}
			else
			{
				trace("External interface is not available");
			}
		}
		
		private function checkStatus(e:Event):void
		{
			var status:Boolean = ExternalInterface.call("checkStatus");
			if (status)
			{
				readyTimer.stop();
				addCallbacks();
			}
		}
		
		private function addCallbacks():void
		{
			// Connection
			ExternalInterface.addCallback("connect", connectClient);
			ExternalInterface.addCallback("disconnect", disconnectClient);
			
			// Initialization
			ExternalInterface.addCallback("initStageOne", initStageOne);
			ExternalInterface.addCallback("generateKey", generateKey);
			ExternalInterface.addCallback("initStageTwo", initStageTwo);
			
			// Encoding
			ExternalInterface.addCallback("encode", encode);
			ExternalInterface.addCallback("decode", decode);
			
			// Notify that Fade is ready
			ExternalInterface.call("callbacksReady");
		}
		
		private function decode(identifier:String, input:String):String
		{
			if (clients[identifier])
				return (clients[identifier] as Client).decode(input);
			return "";
		}
		
		private function encode(identifier:String, input:String):String
		{
			if (clients[identifier])
				return (clients[identifier] as Client).encode(input);
			return "";
		}
		
		private function initStageTwo(identifier:String, code:String):void
		{
			if (clients[identifier])
				(clients[identifier] as Client).initStageTwo(code);
		}
		
		private function generateKey(identifier:String):String
		{
			if (clients[identifier])
			{
				return (clients[identifier] as Client).generateKey();
			}
			return "";
		}
		
		private function initStageOne(identifier:String, code:String):void
		{
			if (clients[identifier])
			{
				
				(clients[identifier] as Client).initStageOne(code);
				(clients[identifier] as Client).addEventListener(Event.ACTIVATE, function(e:Event):void
				{
					ExternalInterface.call("stageOneInitialized", identifier, true);
				});
				
				(clients[identifier] as Client).addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
				{
					ExternalInterface.call("stageOneInitialized", identifier, false);
				});
				
			}
		}
		
		private function connectClient(identifier:String):void
		{
			clients[identifier] = new Client();
		}
		
		private function disconnectClient(identifier:String):void
		{
			delete clients[identifier];
		}
	
	}

}