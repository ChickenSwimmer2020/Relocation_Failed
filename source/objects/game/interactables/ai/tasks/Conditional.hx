package objects.game.interactables.ai.tasks;

class Conditional extends Task {
    public var bools:Array<Bool>;
    public var trueTasks:Array<Task>;
    public var falseTasks:Array<Task>;

    override public function new(ps:Playstate, body:AiBody, bools:Array<Bool>, trueTasks:Array<Task>, falseTasks:Array<Task>) {
        super(ps, body);
        this.bools = bools;
        this.trueTasks = trueTasks;
        this.falseTasks = falseTasks;
    }

    override public function execute() {
        var success:Bool = false;
        for (bool in bools)
        {
            if (bool) {
                success = true;
                break;
            }
        }
        if (success) 
            for (task in trueTasks)
                task.execute();
        else 
            for (task in falseTasks)
                task.execute();
    }
}