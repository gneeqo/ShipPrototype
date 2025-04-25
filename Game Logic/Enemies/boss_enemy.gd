class_name BossEnemy extends BaseEnemy

@export var LeftTentacle:BossTentacle
@export var RightTentacle:BossTentacle
@export var LeftHorn: BossTentacle
@export var RightHorn:BossTentacle
@export var Orb:BossTentacle

@export var TentacleInterval:float = 3
@export var HornsInterval:float = 3
@export var OrbInterval:float = 3

@export var OrbHeight:float = 100

@export var OrbTarget: Node2D


var tentacle_timer:float
var horn_timer:float
var orb_timer:float

var swing_left = true
var swing_right = true
var swing_left_horn = true
var swing_right_horn = true
var bob_orb = true

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

#the left horn doesn't rotate correctly.
#I'm deciding not to spend any more time trying to figure out why.
func swing_horns_out():
    if swing_left_horn:
        #LeftHorn.add_child(BehaviorFactory.rotate(true,LeftTentacle.global_rotation-0.1,1))
        pass
    if swing_right_horn:
        RightHorn.add_child(BehaviorFactory.rotate(false,RightTentacle.global_rotation+0.01,0.25))

func swing_horns_in():
    if swing_left_horn:   
        #LeftHorn.add_child(BehaviorFactory.rotate(false,LeftTentacle.global_rotation+0.1,1))
        pass
    if swing_right_horn:
        RightHorn.add_child(BehaviorFactory.rotate(true,RightTentacle.global_rotation-0.01,0.25))

func bob_orb_up():
    if bob_orb:
        Orb.add_child(BehaviorFactory.translate(OrbTarget.global_position+(Vector2(0,OrbHeight)),2.0))
func bob_orb_down():
    if bob_orb:
        Orb.add_child(BehaviorFactory.translate(OrbTarget.global_position,2.0))


func _ready() -> void:
    tentacle_timer = TentacleInterval
    orb_timer = OrbInterval
    horn_timer = HornsInterval
    super._ready()
    call_deferred("connect_tentacles")
    

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    var ship = get_tree().get_first_node_in_group("referee").player_ship
    if is_instance_valid(ship):
        var toward_ship = (ship.global_position - global_position).normalized()
        
        apply_central_force(toward_ship * 150)


func connect_tentacles():
    LeftTentacle.destroyed.connect(invalidate_left)
    RightTentacle.destroyed.connect(invalidate_right)
    LeftHorn.destroyed.connect(invalidate_left_horn)
    RightHorn.destroyed.connect(invalidate_right_horn)
    Orb.destroyed.connect(invalidate_orb)

func _process(delta: float) -> void:
    tentacle_timer-=delta
    if tentacle_timer <=0:
        tentacle_timer = TentacleInterval
        swing_tentacles_up()
        var downswing = Callable(self,"swing_tentacles_down")
        add_child(BehaviorFactory.delayed_callback(downswing,1))
        
    horn_timer-=delta
    if horn_timer <=0:
        horn_timer = HornsInterval
        swing_horns_out()
        var downswing = Callable(self,"swing_horns_in")
        add_child(BehaviorFactory.delayed_callback(downswing,0.25))

    orb_timer-=delta
    if orb_timer <=0:
        orb_timer = OrbInterval
        bob_orb_up()
        var downswing = Callable(self,"bob_orb_down")
        add_child(BehaviorFactory.delayed_callback(downswing,2))


func invalidate_left():
    swing_left = false
    

func invalidate_right():
    swing_right = false
    
func invalidate_right_horn():
    swing_right_horn = false
    
func invalidate_left_horn():
    swing_left_horn = false
    
func invalidate_orb():
    bob_orb = false

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
    
    get_tree().get_first_node_in_group("camera").begin_shake(1,300)
    get_tree().get_first_node_in_group("hud").PostBigText("Boss Destroyed",1)
    
    if(swing_left):
        LeftTentacle.destroy_enemy()
    if(swing_right):
        RightTentacle.destroy_enemy()
    if(swing_left_horn):
        LeftHorn.destroy_enemy()
    if(swing_right_horn):
        RightHorn.destroy_enemy()
    if(bob_orb):
        Orb.destroy_enemy()
    
