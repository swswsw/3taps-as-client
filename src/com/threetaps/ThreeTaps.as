package com.threetaps
{
	import com.adobe.serializers.json.JSONDecoder;
	import com.adobe.serializers.json.JSONEncoder;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class ThreeTaps
	{
		public static var host:String = "http://3taps.net"
		
		public function ThreeTaps()
		{
		}
		
		public function callGet(uri:String, parameters:Object, callback:Function):void {
			callHttp("GET", uri, parameters, callback);
		}
		
		public function callPost(uri:String, parameters:Object, callback:Function):void {
			callHttp("POST", uri, parameters, callback);
		}
		
		/**
		 * @param method "GET", "POST", "UPDATE", "DELETE"
		 */
		public function callHttp(method:String, uri:String, parameters:Object, callback:Function):void {
			var url:String = host + uri;
			var http:HTTPService = new HTTPService();
			http.url = url;
			http.method = method;
			http.addEventListener(ResultEvent.RESULT, httpResult);
			http.addEventListener(FaultEvent.FAULT, httpFault);
			var token:AsyncToken = http.send(parameters);
			token.callback = callback;
		}
		private function httpResult(evt:ResultEvent):void {
			var token:AsyncToken = evt.token;
			var callback:Function = token.callback;
			var result:Object = {};
			var sResult:String = evt.result as String;
			trace("result="+sResult);
			if (sResult) {
				result = new JSONDecoder().decode(sResult);
			}
			if (callback != null) { callback(result); }
		}
		/**
		 * if fault, will call callback object with a fault object.
		 */
		private function httpFault(evt:FaultEvent):void {
			trace(evt.fault.faultString);
			var token:AsyncToken = evt.token;
			var callback:Function = token.callback;
			var result:Object = {};
			result.fault = evt.fault;
			if (callback != null) { callback(result); }
		}
		
		
	}
}