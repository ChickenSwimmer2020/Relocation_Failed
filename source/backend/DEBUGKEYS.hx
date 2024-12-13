package backend;


/**
    # allows debug keys for quick and easy debugging!
    ## this is a **DEBUG** feature, do not use it in release mode!
    ### oh wait i forgot that it wont work if outside of debug mode-
    ###### why am i even typing this????
**/
class DEBUGKEYS extends FlxObject{
    #if !mobile
    public var _ONEPRESSED:Bool = false;
    public var _TWOPRESSED:Bool = false;
    public function new() {
        super();
    }
    override public function update(elapsed:Float) {
        //toggle hitboxes drawing.
        if(FlxG.keys.anyJustPressed([ONE, NUMPADONE])) {
            if(!_ONEPRESSED){
                FlxG.debugger.drawDebug = true;
                _ONEPRESSED = true;
            } else {
                FlxG.debugger.drawDebug = false;
                _ONEPRESSED = false;
            }
        }
    }
    #end
}