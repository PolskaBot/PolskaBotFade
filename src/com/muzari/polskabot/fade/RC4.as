package com.muzari.polskabot.fade
{
	import flash.utils.ByteArray;
	
	public class RC4
	{
		private var i:int = 0;
		private var j:int = 0;
		
		private var S:ByteArray;
		
		public function RC4(param1:ByteArray = null, param2:ByteArray = null)
		{
			this.S = new ByteArray();
			if (param1)
			{
				init(param1);
			}
		}
		
		public function init(key:ByteArray):void
		{
			var i:int;
			var j:int;
			var t:int;
			for (i = 0; i < 256; ++i)
			{
				S[i] = i;
			}
			j = 0;
			for (i = 0; i < 256; ++i)
			{
				j = (j + S[i] + key[i % key.length]) & 255;
				t = S[i];
				S[i] = S[j];
				S[j] = t;
			}
			this.i = 0;
			this.j = 0;
		}
		
		public function next():uint
		{
			var t:int;
			i = (i + 1) & 255;
			j = (j + S[i]) & 255;
			t = S[i];
			S[i] = S[j];
			S[j] = t;
			return S[(t + S[i]) & 255];
		}
		
		public function encrypt(block:ByteArray):void
		{
			var i:uint = 0;
			while (i < block.length)
			{
				block[i++] ^= next();
			}
		}
		
		public function decrypt(param1:ByteArray):void
		{
			this.encrypt(param1);
		}
	}

}