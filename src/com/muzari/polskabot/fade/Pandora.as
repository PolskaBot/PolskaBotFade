package com.muzari.polskabot.fade
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import com.hurlant.math.BigInteger;
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.crypto.prng.ARC4;
	import com.hurlant.util.Hex;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Pandora
	{
		public var importantBigInteger:BigInteger;
		public static const firstCode:BigInteger = new BigInteger("5478a9105faffc1e47e49ccb6791a55a8d01fc32607706d18670a81cde19e1cffc0efa358d4a14c68934a57b437ba52b752f8dfffe7af18de93c0d8418bd2f34");
		public static const secondCode:BigInteger = new BigInteger("d0155aaf4104778513372dae23747f500850e67e4a08fc6faf62f5bcd3c882530f9e5a57e390bc80a5f0b1e7075d100293f5d1e804e7253e53e9d40a11240ae7");
		
		protected var stageOne:Wrapper;
		protected var stageTwoEncode:RC4;
		protected var stageTwoDecode:RC4;
		
		protected var stageOneActive:Boolean;
		public var stageTwoActive:Boolean;
		
		public function Pandora()
		{
			stageOne = new Wrapper();
			stageTwoEncode = new RC4();
			stageTwoDecode = new RC4();
		}
		
		public function initStageOne(param1:ByteArray):void
		{
			this.stageOne.load(param1);
			stageOneActive = true;
		}
		
		public function generateObfuscationCallback():ByteArray
		{
			trace("Generating obfuscation callback");
			var _local_5:int;
			var _local_6:String;
			var _local_1:String = new String();
			for (var i:int = 0; i < 128; i++)
			{
				_local_5 = (Math.random() * 0x0100);
				_local_6 = _local_5.toString(16);
				if (_local_6.length == 1)
				{
					_local_6 = ("0" + _local_6);
				}
				;
				_local_1 = (_local_1 + _local_6);
			}
			;
			importantBigInteger = new BigInteger(_local_1, 16);
			var _local_3:BigInteger = firstCode.modPow(importantBigInteger, secondCode);
			var local3ToBytes:ByteArray = _local_3.toByteArray();
			trace("Obfuscation callback generated, size " + local3ToBytes.length);
			return local3ToBytes;
		}
		
		public function initStageTwo(param1:ByteArray):void
		{
			var _loc3_:ByteArray = null;
			var _loc4_:BigInteger = null;
			var _loc6_:BigInteger = null;
			var _loc7_:BigInteger = null;
			var secretKey:ByteArray = null;
			var _loc2_:RSAKey = new RSAKey(new BigInteger("84c16e0a5860d56409207e6b542f168de24e434198e68b363dec817b77a594a17f968f177e871bfd626d139099cb3af0070cf2a03b46d1404503dc95d5a72f7c61e36b61967be50bd6bdf8d3376171b00fce65c521bc3267cdf7e6b0c3d725c9"), 65537);
			try
			{
				_loc3_ = new ByteArray();
				_loc2_.verify(param1, _loc3_, param1.length);
				_loc3_.position = 0;
				_loc4_ = new BigInteger(_loc3_);
				_loc7_ = _loc4_.modPow(importantBigInteger, secondCode);
				secretKey = new ByteArray();
				_loc7_.toByteArray().readBytes(secretKey, 0, 16);
				stageTwoEncode.init(secretKey);
				stageTwoDecode.init(secretKey);
				stageTwoActive = true;
			}
			catch (error:Error)
			{
				trace(error);
			}
		}
		
		public function encode(param1:ByteArray):ByteArray
		{
			var out:ByteArray;
			if (stageTwoActive)
			{
				stageTwoEncode.encrypt(param1);
			}
			out = this.stageOne.encode(param1);
			return out;
		}
		
		public function decode(param1:ByteArray):ByteArray
		{
			var out:ByteArray = this.stageOne.decode(param1);
			if (stageTwoActive)
			{
				stageTwoDecode.decrypt(out);
			}
			return out;
		}
		
		public function getStageOne():Wrapper
		{
			return stageOne;
		}
	
	}

}