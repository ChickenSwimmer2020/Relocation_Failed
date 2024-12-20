package objects;

import flixel.FlxState;
import flixel.FlxG;
import openfl.events.MouseEvent;
import flixel.group.FlxSpriteGroup;
import objects.ChapterBox;

class ChapterSelecterGroup extends FlxSpriteGroup {
    private var chapterNames:Array<String> = ["test", "Chapter 2", "Chapter 3", "Chapter 4", "Chapter 5"];
    private var chapterImages:Array<FlxGraphic> = [null, null, null, null, null]; // Replace `null` with actual graphics if needed
    private var chapterLocks:Array<Bool> = [false, true, false, false, true]; // Example lock states

    private var chapterBoxes:Array<ChapterBox> = [];
    private var currentOffset:Float = 0;
    private var scrollSpeed:Float = 15;
    private var startX:Float = 100;
    private var spacing:Float = 150;

    private var minOffset:Float = 0;
    private var maxOffset:Float;
    private var lastOffset:Float = -1; // To track changes in `currentOffset`


    public var chapterCamera:FlxCamera;

    override public function new(?camera:FlxCamera = null):Void {
        super();
        chapterCamera = camera;
        // Precompute maximum offset
        maxOffset = computeMaxOffset();

        // Create and position ChapterBoxes
        createChapterBoxes();

        // Ensure initial positioning is correct
        updateChapterPositions();

        // Add mouse wheel listener (ensure it’s added only once)
        FlxG.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    private function computeMaxOffset():Float {
        return (chapterNames.length - 1) * spacing;
    }

    private function createChapterBoxes():Void {
        for (i in 0...chapterNames.length) {
            var chapter = createChapterBox(i);
            chapterBoxes.push(chapter);
            if (chapterCamera != null) chapter.camera = chapterCamera;
            add(chapter);
        }
    }

    private function createChapterBox(index:Int):ChapterBox {
        return new ChapterBox(
            startX + index * spacing,
            100, // Fixed Y position
            chapterImages[index],
            chapterNames[index],
            onChapterClick(index),
            chapterLocks[index]
        );
    }

    private function updateChapterPositions():Void {
        // Update positions only if the offset has changed
        if (currentOffset != lastOffset) {
            for (i in 0...chapterBoxes.length) {
                chapterBoxes[i].x = startX + i * spacing - currentOffset;
            }
            lastOffset = currentOffset;
        }
    }

    private function onMouseWheel(event:MouseEvent):Void {
        // Adjust offset based on scroll direction
        currentOffset = clamp(
            currentOffset + (if (event.delta < 0) scrollSpeed else -scrollSpeed),
            minOffset,
            maxOffset
        );

        // Update chapter positions
        updateChapterPositions();
    }

    private function clamp(value:Float, min:Float, max:Float):Float {
        return Math.max(min, Math.min(max, value));
    }

    private function onChapterClick(index:Int):Void -> Void {
        return function():Void {
            trace("Selected: " + chapterNames[index]);
            switch(index) {
                case 0: // Chapter 1
                    FlxG.switchState(new Playstate('level1'));
                case 1: // Chapter 2
                    // Handle Chapter 2 click
                case 2: // Chapter 3
                    // Handle Chapter 3 click
                case 3: // Chapter 4
                    // Handle Chapter 4 click
                case 4: // Chapter 5
                    // Handle Chapter 5 click
            }
        };
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        // Update chapter positions in case of dynamic changes (optional safeguard)
        updateChapterPositions();
   
    }
}