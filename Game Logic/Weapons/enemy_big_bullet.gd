class_name EnemyBigBullet extends RigidBody2D

@export var thrust_jerk:float
@export var turn_jerk:float 



@export var max_thrust:float
@export var max_vel:float

@export var max_turn_vel : float
@export var max_turn_accel : float

@export var total_lifetime:float

@export var retarget_interval:float
@onready var retarget_timer = retarget_interval


@onready var lifetime = total_lifetime

var curr_thrust:float = 0
var curr_turn_accel: float =0


var ship: Node2D
var target: Vector2


var missile_inertia:float:
    get:
        return 1.0 / PhysicsServer2D.body_get_direct_state(get_rid()).inverse_inertia

func _ready():
    var ref:referee = get_tree().get_first_node_in_group("referee")
    ship = ref.player_ship
    
    if not is_instance_valid(ship):
        return
    target = ship.global_position

func _process(delta:float):
    lifetime -= delta
    if lifetime <=0:
        destroy()
        
    retarget_timer -= delta
    if retarget_timer <=0:
        retarget_timer = retarget_interval
        var ref:referee = get_tree().get_first_node_in_group("referee")
        ship = ref.player_ship
        
        if not is_instance_valid(ship):
            return
        target = ship.global_position

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    
    var ref:referee = get_tree().get_first_node_in_group("referee")
    ship = ref.player_ship
    
    if not is_instance_valid(ship):
        return
    
    var current_facing: Vector2 = Vector2.from_angle(global_rotation)
    var facing_toward_target:Vector2 = (target - global_position).normalized()
    var angle_diff = asin(current_facing.cross(facing_toward_target) /(abs(current_facing).dot(abs(facing_toward_target))))
    
    if angle_diff > 0:
        curr_turn_accel += turn_jerk
    elif angle_diff <0:
        curr_turn_accel -= turn_jerk
        
    curr_thrust += thrust_jerk
    
    curr_turn_accel = clampf(curr_turn_accel,-max_turn_accel,max_turn_accel)
    curr_thrust = clampf(curr_thrust,-max_thrust,max_thrust)
    
    var thrust_vec = current_facing * mass * curr_thrust
    
    var torque = curr_turn_accel * missile_inertia 
    
    
    state.apply_central_force(thrust_vec)
    state.apply_torque(torque)
    
    #enforce maximums
    if(state.linear_velocity.length() > max_vel):
        var direction = state.linear_velocity.normalized()
        state.linear_velocity = direction * max_vel
    
    state.angular_velocity = clampf(state.angular_velocity,-max_turn_vel,max_turn_vel)
        
    
    
func kill():
    queue_free()
    

 
func destroy():
    if $Sprite2D.visible:
        #call_deferred("add_explosion")
        $Sprite2D.set_deferred("visible",false)
        add_child(BehaviorFactory.delayed_callback(Callable(self,"kill"),2))

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("fence") or body.is_in_group("player"):
        destroy()
