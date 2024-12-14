package backend;

import flixel.input.keyboard.FlxKey;


/**
    # allows debug keys for quick and easy debugging!
    ## this is a **DEBUG** feature, do not use it in release mode!
    ### oh wait i forgot that it wont work if outside of debug mode-
    ###### why am i even typing this????
**/
class DEBUGKEYS{
    #if (!mobile && debug)
    public var pressed:Array<Bool> = [false, false];
    public var numberKeys:Array<Array<FlxKey>> = 
    [
        [ZERO, NUMPADZERO],
        [ONE, NUMPADONE],
        [TWO, NUMPADTWO],
        [THREE, NUMPADTHREE],
        [FOUR, NUMPADFOUR],
        [FIVE, NUMPADFIVE],
        [SIX, NUMPADSIX],
        [SEVEN, NUMPADSEVEN],
        [EIGHT, NUMPADEIGHT],
        [NINE, NUMPADNINE]
    ];
    public var keyResponses:Array<() -> Void> = 
    [
        //toggle hitboxes drawing.
        () -> { FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug; },
        () -> {},
        () -> {},
        () -> {},
        () -> {},
        () -> {},
        () -> {},
        () -> {},
        () -> {},
        () -> {}
    ];
    public function new() return;
    public function update(elapsed:Float) {
        for (keyID in 0...numberKeys.length){
            pressed[keyID] = FlxG.keys.anyJustPressed(numberKeys[keyID]);
            if (pressed[keyID]) keyResponses[keyID]();
        }
    }
    #end
}