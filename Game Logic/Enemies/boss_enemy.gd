class_name BossEnemy extends BaseEnemy

@export var LeftTentacle:BossTentacle
@export var RightTentacle:BossTentacle
@export var BossMissile:PackedScene
@export var BossBullet:PackedScene
@export var BossMinion:PackedScene

@export var TentacleInterval:float = 3

var tentacle_timer:float

var swing_left = true
var swing_right = true

func swing_tentacles_up():
    if swing_left:
        LeftTentacle.add_child(BehaviorFactory.rotate(true,LeftTentacle.global_rotation-1.2,1))
    if swing_right:
        RightTentacle.add_child(BehaviorFactory.rotate(false,RightTentacle.global_rotation+1.2,1))

func swing_tentacles_down():
    if swing_left:   
        LeftTentacle.add_child(BehaviorFactory.rotate(false,LeftTentacle.global_rotation+1.2,1))
    if swing_right:
        RightTentacle.add_child(BehaviorFactory.rotate(true,RightTentacle.global_rotation-1.2,1))

func _ready() -> void:
    tentacle_timer = TentacleInterval
    super._ready()
    call_deferred("connect_tentacles")
    

func connect_tentacles():
    LeftTentacle.destroyed.connect(invalidate_left)
    RightTentacle.destroyed.connect(invalidate_right)

func _process(delta: float) -> void:
    tentacle_timer-=delta
    if tentacle_timer <=0:
        tentacle_timer = TentacleInterval
        swing_tentacles_up()
        var downswing = Callable(self,"swing_tentacles_down")
        add_child(BehaviorFactory.delayed_callback(downswing,1))


func invalidate_left():
    swing_left = false
    

#don't really know why, but this doesn't work.
#just leave the tentacles parented, it doesn't matter that much
func reparent_left():
    LeftTentacle.reparent(get_parent())
    
func reparent_right():
    RightTentacle.reparent(get_parent())

func invalidate_right():
    swing_right = false
    
func kill():
    queue_free()
    
func hide_body():
    $Sprite2D.visible = false

func destroy_enemy():
    var giblets = death_particle.instantiate()
    add_child(giblets)
    for gib in giblets.get_children():
        gib.emitting = true
    
    var hide_func = Callable(self,"hide_body")
    var kill_func = Callable(self, "kill")
    
    $PhysicsCollision.set_deferred("disabled",true)
    
    $Area2D/NonPhysicsCollision.set_deferred("disabled",true)
    
    add_child(BehaviorFactory.delayed_callback(hide_func,0.1))
    add_child(BehaviorFactory.delayed_callback(kill_func,1))
    
    get_tree().get_first_node_in_group("camera").begin_shake(1,500)
    get_tree().get_first_node_in_group("hud").PostBigText("Boss Destroyed",1)
