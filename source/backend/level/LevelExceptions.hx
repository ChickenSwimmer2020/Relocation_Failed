package backend.level;

class LevelAssetsException extends Exception {
	override public function toString():String {
		var str = 'Level Assets Exception: $msg';
		if (stack != '')
			str += ' | Stack: \n$stack';
		else
			str += ' | PosInfos: \n${Functions.formatPosInfos(posInfos)}';
		return str;
	}
}


class LevelNullException extends Exception {
	override public function toString():String {
		var str = 'Level Null Exception: $msg';
		if (stack != '')
			str += ' | Stack: \n$stack';
		else
			str += ' | PosInfos: \n${Functions.formatPosInfos(posInfos)}';
		return str;
	}
}

class LevelParseErrorException extends Exception {
	override public function toString():String {
		var str = 'Level Parse Error Exception: $msg';
		if (stack != '')
			str += ' | Stack: \n$stack';
		else
			str += ' | PosInfos: \n${Functions.formatPosInfos(posInfos)}';
		return str;
	}
}
