class_name BossEnemy extends BaseEnemy

@export var LeftTentacle:BossTentacle
@export var RightTentacle:BossTentacle
@export var BossMissile:PackedScene
@export var BossBullet:PackedScene
@export var BossMinion:PackedScene

@export var TentacleInterval:float = 3

var tentacle_timer:float

func swing_tentacles_up():
    LeftTentacle.add_child(BehaviorFactory.rotate(true,LeftTentacle.global_rotation-1.2,1))
    RightTentacle.add_child(BehaviorFactory.rotate(false,RightTentacle.global_rotation+1.2,1))

func swing_tentacles_down():
    LeftTentacle.add_child(BehaviorFactory.rotate(false,LeftTentacle.global_rotation+1.2,1))
    RightTentacle.add_child(BehaviorFactory.rotate(true,RightTentacle.global_rotation-1.2,1))

func _ready() -> void:
    tentacle_timer = TentacleInterval
    super._ready()

func _process(delta: float) -> void:
    tentacle_timer-=delta
    if tentacle_timer <=0:
        tentacle_timer = TentacleInterval
        swing_tentacles_up()
        var downswing = Callable(self,"swing_tentacles_down")
        add_child(BehaviorFactory.delayed_callback(downswing,1))
