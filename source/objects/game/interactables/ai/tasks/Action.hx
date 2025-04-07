package objects.game.interactables.ai.tasks;

import objects.game.controllables.Player;
import flixel.math.FlxAngle;
import flixel.FlxG;
import openfl.events.Event;
import objects.game.interactables.ai.Task;
import objects.game.interactables.ai.Task.CancellableTask;

enum abstract ActionType(String) from String to String {
    var MOVE_TO     = 'mvTo';   // move to a specific coordinate or object
    var MOVE_IN_DIR = 'mvDir';  // move in a given direction
    var TELEPORT    = 'tp';     // teleport to a specific location
    var ATTACK      = 'attk';   // perform an attack
    var IDLE        = 'idle';   // do literally nothing
    var ADD_VEL     = 'addVel'; // add velocity
    var FOLLOW_PATH = 'flpth';  // follow a path
    var FLEE        = 'flee';   // run away from smth idk
}

// Very basic attack type enum, can be expanded later
enum abstract AtackType(Int) from Int to Int {
    var MELEE  = 0;
    var RANGED = 1;
}

class Action extends Task {
    public var actionType:ActionType;
    public var actionTask:Task;

    function actionTypeToInstance(params:Array<Dynamic>):CancellableTask {
        switch(actionType) {
            case MOVE_TO:
                return new ActionMoveTo(ps, body, params[0], params[1], params[2], params[3]);
            case MOVE_IN_DIR:
                return new ActionMoveInDir(ps, body, params[0], params[1]);
            default:
            case TELEPORT:
                return new ActionTeleport(ps, body, params[0], params[1], params[2]);
            case ATTACK:
                return new ActionAttack(ps, body, params[0], params[1], params[2], params[3], params[4], params[5]);
            // case IDLE:
                // return new ActionIdle(ps, body);
            // case ADD_VEL:
                // return new ActionAddVel(ps, body, params[0], params[1], params[2]);
            // case FOLLOW_PATH:
                // return new ActionFollowPath(ps, body, params[0], params[1]);
            // case FLEE:
                // return new ActionFlee(ps, body, params[0], params[1], params[2]);
        }
        return null;
    }

    override public function new(ps:Playstate, body:AiBody, actionType:ActionType, params:Array<Dynamic>) {
        super(ps, body);
        this.actionType = actionType;
        actionTask = actionTypeToInstance(params);
    }
}

class ActionAttack extends ActionMoveTo {
    public var hitTarget:Player;
    public var attackType:Int = 0;
    public var damage:Float = 0;
    public var knockback:Float = 0;
    public var attackRadius:Float = 20;

    override public function new(ps:Playstate, body:AiBody, hitTarget:Player, speed:Float, attackType:Int, damage:Float, knockback:Float, attackRadius:Float) {
        this.hitTarget = hitTarget;
        this.attackType = attackType;
        this.damage = damage;
        this.knockback = knockback;
        this.attackRadius = attackRadius;
        super(ps, body, hitTarget.x, hitTarget.y, hitTarget.z, speed);
    }

    var state:Int = 0;
    override function onMove(_):Void {
        var dx = targetX - body.x;
        var dy = targetY - body.y;
        var dz = targetZ - body.z;
        var distSq = dx * dx + dy * dy + dz * dz;
        
        if (state == 0) {
            if (distSq > attackRadius * attackRadius) {
                var dist = Math.sqrt(distSq);
                var norm = (speed * FlxG.elapsed) / dist;
                body.x += dx * norm;
                body.y += dy * norm;
                body.z += dz * norm;
            } else {
                state = 1;
            }
        } else if (state == 1) {
            if (distSq > attackRadius * attackRadius) {
                state = 0;
                return;
            }
            
            if (attackType == AtackType.MELEE) {
                hitTarget.Health -= damage;
                
                var kdx = hitTarget.x - body.x;
                var kdy = hitTarget.y - body.y;
                var kdz = hitTarget.z - body.z;
                var kDist = Math.sqrt(kdx * kdx + kdy * kdy + kdz * kdz);
                if (kDist != 0) {
                    kdx /= kDist;
                    kdy /= kDist;
                    kdz /= kDist;
                }

                hitTarget.physVelocity.x = kdx * knockback;
                hitTarget.physVelocity.y = kdy * knockback;
                hitTarget.physVelocity.z = kdz * knockback;
            } else if (attackType == AtackType.RANGED) {
                // Ranged attack logic goes here (e.g., instantiating a projectile).
            }
        }
    }
    
}

class ActionTeleport extends CancellableTask {
    public var targetX:Float = 0;
    public var targetY:Float = 0;
    public var targetZ:Float = 0;

    override public function new(ps:Playstate, body:AiBody, targetX:Float, targetY:Float, targetZ:Float) {
        super(ps, body);
        this.targetX = targetX;
        this.targetY = targetY;
        this.targetZ = targetZ;
    }

    override public function execute() {
        body.x = targetX;
        body.y = targetY;
        body.z = targetZ;
    }
}

class ActionMoveInDir extends CancellableTask {
    public var dirInDeg:Float = 0;
    public var speed:Float = 0;

    override public function new(ps:Playstate, body:AiBody, dirInDeg:Float, speed:Float) {
        super(ps, body);
        this.dirInDeg = dirInDeg;
        this.speed = speed;
    }

    override public function execute() {
        FlxG.stage.addEventListener(Event.ENTER_FRAME, onMove);
    }

    override public function cancel() {
        FlxG.stage.removeEventListener(Event.ENTER_FRAME, onMove);
    }


    function onMove(_)
    {
        var radians = dirInDeg * FlxAngle.TO_RAD;
        var dx = Math.cos(radians) * speed * FlxG.elapsed;
        var dy = Math.sin(radians) * speed * FlxG.elapsed;
        body.x += dx;
        body.y += dy;
    }
}

class ActionMoveTo extends CancellableTask {
    public var targetX:Float = 0;
    public var targetY:Float = 0;
    public var targetZ:Float = 0;
    public var speed:Float = 0;

    override public function new(ps:Playstate, body:AiBody, targetX:Float, targetY:Float, targetZ:Float, speed:Float) {
        super(ps, body);
        this.targetX = targetX;
        this.targetY = targetY;
        this.targetZ = targetZ;
        this.speed = speed;
    }

    override public function execute() {
        FlxG.stage.addEventListener(Event.ENTER_FRAME, onMove);
    }

    override public function cancel() {
        FlxG.stage.removeEventListener(Event.ENTER_FRAME, onMove);
    }


    function onMove(_)
    {
        var dx = targetX - body.x;
        var dy = targetY - body.y;
        var dz = targetZ - body.z;
        var distSq = dx * dx + dy * dy + dz * dz;
        var speedSq = speed * speed;
        
        if (distSq > speedSq) {
            var norm = speed / Math.sqrt(distSq);
            body.x += dx * norm;
            body.y += dy * norm;
            body.z += dz * norm;
        } else {
            body.x = targetX;
            body.y = targetY;
            body.z = targetZ;
            cancel();
        }
    }
}