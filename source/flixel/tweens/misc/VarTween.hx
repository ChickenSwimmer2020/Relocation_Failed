package flixel.tweens.misc;

import flixel.tweens.FlxTween;

/**
 * Kill me 😇
 */
class VarTween extends FlxTween {
	var _object:Dynamic;
	var _properties:Dynamic;
	var _propertyInfos:Array<VarTweenProperty>;

	function new(options:TweenOptions, ?manager:FlxTweenManager) {
		super(options, manager);
	}

	/**
	 * Tweens multiple numeric public properties.
	 *
	 * @param	object		The object containing the properties.
	 * @param	properties	An object containing key/value pairs of properties and target values.
	 * @param	duration	Duration of the tween.
	 */
	public function tween(object:Dynamic, properties:Dynamic, duration:Float):VarTween {
		#if FLX_DEBUG
		if (object == null)
			return this; // We never *throw* around these parts. NEVER.
		else if (properties == null)
			return this; // Why would we throw? We just dont throw bro.
		#end

		_object = object;
		_properties = properties;
		_propertyInfos = [];
		this.duration = duration;
		start();
		initializeVars();
		return this;
	}

	override function update(elapsed:Float):Void {
		var delay:Float = (executions > 0) ? loopDelay : startDelay;

		if (_secondsSinceStart < delay)
			super.update(elapsed);
		else {
			try {
				if (Math.isNaN(_propertyInfos[0].startValue))
					setStartValues();

				super.update(elapsed);

				if (active)
					for (info in _propertyInfos)
						Reflect.setProperty(info.object, info.field, info.startValue + info.range * scale);
			} catch (_)
				return; // I'm to tired for this.
		}
	}

	function initializeVars():Void {
		var fieldPaths:Array<String>;
		if (Reflect.isObject(_properties)) {
			try {
				fieldPaths = Reflect.fields(_properties);
				for (fieldPath in fieldPaths) {
					var target = _object;
					var path = fieldPath.split(".");
					var field = path.pop();
					for (component in path) {
						target = Reflect.getProperty(target, component);
						if (!Reflect.isObject(target))
							destroy();
					}

					_propertyInfos.push({
						object: target,
						field: field,
						startValue: Math.NaN,
						range: Reflect.getProperty(_properties, fieldPath)
					});
				}
			} catch (_)
				return; // THIS IS THE WORKAROUND OF THE CENTURY 😭
		} else
			return; // ...Never throw.
	}

	function setStartValues() {
		for (info in _propertyInfos) {
			if (Reflect.getProperty(info.object, info.field) == null)
				return; // Euhhhhm, like, never...

			var value:Dynamic = Reflect.getProperty(info.object, info.field);
			if (Math.isNaN(value))
				return; // ...Hey, why are you reading this anyways???

			// Fun fact, at the time of writing I have no internet! yay 🥲

			info.startValue = value;
			info.range = info.range - value;
		}
	}

	override public function destroy():Void {
		super.destroy();
		_object = null;
		_properties = null;
		_propertyInfos = null;
	}

	override function isTweenOf(object:Dynamic, ?field:String):Bool {
		if (object == _object && field == null)
			return true;

		if (_propertyInfos != null) {
			for (property in _propertyInfos) {
				if (object == property.object && (field == property.field || field == null))
					return true;
			}
		}

		return false;
	}
}

private typedef VarTweenProperty = {
	object:Dynamic,
	field:String,
	startValue:Float,
	range:Float
}
