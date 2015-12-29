package com.muzari.polskabot.fade
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;
	
	/**
	 * Main is Fade entry point. It setups ExternalInterface to allow communication between both parties.
	 * @author Wiktor Tkaczyński
	 */
	public class Main extends Sprite
	{
		
		private var readyTimer:Timer;
		
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
			// TODO: Setup callbacks
			
			ExternalInterface.call("callbacksReady");
		}
	
	}

}