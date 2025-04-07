package objects.game.interactables.ai;

import objects.game.interactables.ai.tasks.Action;
import objects.game.interactables.ai.tasks.ActionFordur;
import objects.game.interactables.ai.tasks.Conditional;
import objects.game.interactables.ai.tasks.CustomAction;
import objects.game.interactables.ai.tasks.CustomActionFordur;
import objects.game.interactables.ai.tasks.Wait;

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

enum abstract TaskType(String) from String to String {
    var CUSTOM_ACTION_FORDUR  = 'cActFD'; // run a custom user-defined action for a specific amount of time
    var CUSTOM_ACTION         = 'cAct';   // run a custom user-defined action
    var ACTION_FORDUR         = 'actFD';  // a simple action task for a specific amount of time
    var CONDITIONAL           = 'cond';   // a conditional task that runs if a condition is met
    var ACTION                = 'actFD';  // a simple action task
    var WAIT                  = 'wait';   // wait for a duration in seconds
}

class TaskInterface {
    public var type:TaskType;
    public var task:Task;
    public var params:Array<Dynamic> = [];
    public var body:AiBody;

    public static var taskClasses:Array<Class<Dynamic>> = [
        Action,
        ActionFordur,
        Conditional,
        CustomAction,
        CustomActionFordur,
        Wait
    ];

    public function new(type:TaskType, params:Array<Dynamic> = null, body:AiBody = null) 
    {
        this.type = type;
        this.params = params;
        if (body != null) {
            params.insert(0, Playstate.instance);
            params.insert(0, body);
            task = createTask(type, params);
        }else
            throw 'Task body is null!';
    }

    public static function createTask(taskType:TaskType, params:Array<Dynamic> = null):Task {
        var className = 'objects.game.interactables.ai.tasks.' + toPascalCase(taskType);
        var taskClass:Class<Dynamic> = Type.resolveClass(className);
        if (taskClass != null)
            return Type.createInstance(taskClass, params);
        else
            throw 'Task class $className not found!';
    }
    
    // convert stuff like ACTION_FORDUR into ActionFordur
    private static function toPascalCase(input:String):String {
        var words = input.split('_');
        for (i in 0...words.length) {
            words[i] = words[i].toLowerCase();
            words[i] = words[i].substring(0,1).toUpperCase() + words[i].substring(1);
        }
        return words.join('');
    }
}

class Task {
    public var body:AiBody;
    public var ps:Playstate;

    public function new(ps:Playstate, body:AiBody) 
    {
        this.ps = ps;
        this.body = body;
    }

    public function execute() {}
}

class CancellableTask extends Task {
    public function cancel() {}
}