package debug.leveleditor.ui;

/**
 * simple parameters for the RFUI button.
 * @param width button width
 * @param height button height
 * @param text the text of the button
 * @param textBaseColor the base color of the button
 * @param textHoverColor (OPTIONAL) the text color when hovered
 * @param textClickColor (OPTIONAL) the text color when clicked
 * @param alpha (OPTIONAL) the alpha of the back of the button (excludes text)
 * @param baseColor base button color
 * @param hoverColor button base hover color
 * @param clickColor button base click color
 */
typedef ButtonMetaData = {
    width:Float,
    height:Float,
    text:String,
    ?textSize:Int,
    textBaseColor:FlxColor,
    ?textHoverColor:FlxColor,
    ?textClickColor:FlxColor,
    ?alpha:Float,
    baseColor:FlxColor,
    hoverColor:FlxColor,
    clickColor:FlxColor
}

class EditorUIButton extends FlxSpriteGroup{
    private var onClick_RETURN:Dynamic = null;
    private var varibles:ButtonMetaData;
    private var clicked:Void->Void;

    private var ogsprscale:Array<Float> = [];
    private var ogtxtscale:Array<Float> = [];

    public var txt:FlxText;
    public var spr:FlxSprite;

    /**
     * create a new instance of a RFUI button
     * @param x menu X position
     * @param y menu Y position
     * @param onClick what to do when the button is clicked
     * @param Meta the extra data of the button.
     */
    public function new(x:Float, y:Float, onClick:Void->Void, Meta:ButtonMetaData){
        super(x, y);
        varibles = Meta;
        clicked = onClick;
        spr = new FlxSprite(0, 0).makeGraphic(1, 1, Meta.baseColor);
        spr.setGraphicSize(Meta.width, Meta.height);
        spr.updateHitbox();
        add(spr);
        if(Meta.alpha != null)
            spr.alpha = Meta.alpha;
        txt = new FlxText(0, 0, spr.width, Meta.text, Meta.textSize != null ? Meta.textSize : 16, true);
        txt.alignment = CENTER;
        txt.color = Meta.textBaseColor;
        add(txt);

        ogsprscale = [Meta.width, Meta.height]; //keep the original scaling stuff.
    }
    override public function update(elapsed:Float){
        super.update(elapsed);

        if(FlxG.mouse.overlaps(this)){
            spr.color = varibles.hoverColor;
            if(varibles.textHoverColor != null) txt.color = varibles.textHoverColor;
            if(FlxG.mouse.pressed){
                spr.color = varibles.clickColor;
                if(varibles.textClickColor != null) txt.color = varibles.textClickColor;
                if(FlxG.mouse.justPressed){
                    spr.setGraphicSize(ogsprscale[0] - 0.2, ogsprscale[1] -0.2);
                    if(varibles.textSize != null)
                        txt.size = varibles.textSize - 2;
                    else
                        txt.size = 14;
                    txt.updateHitbox();
                    clicked();
                }
            }else{
                spr.setGraphicSize(ogsprscale[0], ogsprscale[1]);
                if(varibles.textSize != null)
                    txt.size = varibles.textSize;
                else
                    txt.size = 16;
                txt.updateHitbox();
            }
        }else{
            spr.color = FlxColor.WHITE;
            txt.color = FlxColor.WHITE;
        }
    }
}