package backend;

import haxe.PosInfos;

class Exception {
	/**
	 * The message of this exception.
	 */
	public var msg:String;

	/**
	 * The call stack of the error.
	 */
	public var stack:String;

	/**
	 * The posInfos of the exception.
	 */
	public var posInfos:PosInfos;

	public function new(msg:String, stack:String, ?posInfos:PosInfos) {
		this.msg = msg;
		this.stack = stack;
		this.posInfos = posInfos;
	}

	public function toString():String {
		var str = 'Exception: $msg';
		if (stack != '')
			str += ' | Stack: \n$stack';
		else
			str += ' | PosInfos: \n${Functions.formatPosInfos(posInfos)}';
		return str;
	}
}
