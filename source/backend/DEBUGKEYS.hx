package backend;


/**
    # allows debug keys for quick and easy debugging!
    ## this is a **DEBUG** feature, do not use it in release mode!
    ### oh wait i forgot that it wont work if outside of debug mode-
    ###### why am i even typing this????
**/
class DEBUGKEYS extends FlxObject{
    #if !mobile
    public function new() {
        super();
    }
    override public function update(elapsed:Float) {
        //toggle debug drawing.
        if(FlxG.keys.anyJustPressed([ZERO, NUMPADZERO])) {
            FlxG.debugger.drawDebug = true;
        }
    }
    #end
}