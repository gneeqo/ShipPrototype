class_name BaseEnemy extends RigidBody2D

@export var thrust_jerk:float
@export var turn_jerk:float 



@export var max_thrust:float
@export var max_vel:float

@export var max_turn_vel : float
@export var max_turn_accel : float

@export var max_health:int = 2
@export var death_particle : PackedScene 


var health = max_health

var curr_thrust:float = 0
var curr_turn_accel: float =0

var curr_knockback_vector := Vector2(0,0)

var target: Node2D


var enemy_inertia:float:
    get:
        return 1.0 / PhysicsServer2D.body_get_direct_state(get_rid()).inverse_inertia



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
    


func take_damage():
    health -=1
    if health <= 0:
        destroy_enemy()


func add_to_knockback(knockback:Vector2):
    curr_knockback_vector += knockback

func apply_knockback(state: PhysicsDirectBodyState2D):
    state.linear_velocity += curr_knockback_vector
   

func take_knockback(direction:Vector2,intensity:float):
    add_child(BehaviorFactory.knockback(direction,0.4,intensity))


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    
    if not is_instance_valid(target):
        target = get_tree().get_first_node_in_group("player")
        if not is_instance_valid(target):
            return
       
    
    var current_facing: Vector2 = Vector2.from_angle(global_rotation)
    var facing_toward_target:Vector2 = (target.global_position - global_position).normalized()
    var angle_diff = asin(current_facing.cross(facing_toward_target) /(abs(current_facing).dot(abs(facing_toward_target))))
    
    if angle_diff > 0:
        curr_turn_accel += turn_jerk
    elif angle_diff <0:
        curr_turn_accel -= turn_jerk
        
    curr_thrust += thrust_jerk
    
    curr_turn_accel = clampf(curr_turn_accel,-max_turn_accel,max_turn_accel)
    curr_thrust = clampf(curr_thrust,-max_thrust,max_thrust)
    
    var thrust_vec = current_facing * mass * curr_thrust
    
    var torque = curr_turn_accel * enemy_inertia 
    
    
    state.apply_central_force(thrust_vec)
    state.apply_torque(torque)
    
    #enforce maximums
    if(state.linear_velocity.length() > max_vel):
        var direction = state.linear_velocity.normalized()
        state.linear_velocity = direction * max_vel
    
    state.angular_velocity = clampf(state.angular_velocity,-max_turn_vel,max_turn_vel)
    
    apply_knockback(state)
    curr_knockback_vector = Vector2(0,0)  
    






    


func _on_area_2d_body_entered(body: Node2D) -> void:
   if body.is_in_group("player_bullet") or body.is_in_group("player"):
        take_damage()
        var velocity = (PhysicsServer2D.body_get_direct_state(body.get_rid()).linear_velocity)
        take_knockback(velocity.normalized(),clampf(velocity.length(),0,750))
