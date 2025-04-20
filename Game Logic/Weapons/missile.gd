class_name Missile extends RigidBody2D

@export var thrust_jerk:float
@export var turn_jerk:float 



@export var max_thrust:float
@export var max_vel:float

@export var max_turn_vel : float
@export var max_turn_accel : float


var curr_thrust:float = 0
var curr_turn_accel: float =0



var target: Node2D


var missile_inertia:float:
    get:
        return 1.0 / PhysicsServer2D.body_get_direct_state(get_rid()).inverse_inertia




func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    
    if not is_instance_valid(target):
        var enemies:Array[Node] = get_tree().get_nodes_in_group("enemy")
        var closest_enemy = enemies.front()
        var closest_distance = (closest_enemy.global_position - global_position).length()
        for enemy in enemies:
            var new_distance = (enemy.global_position - global_position).length()
            if new_distance < closest_distance:
                closest_distance = new_distance
                closest_enemy = enemy
        target = closest_enemy
    
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
    
    var torque = curr_turn_accel * missile_inertia 
    
    
    state.apply_central_force(thrust_vec)
    state.apply_torque(torque)
    
    #enforce maximums
    if(state.linear_velocity.length() > max_vel):
        var direction = state.linear_velocity.normalized()
        state.linear_velocity = direction * max_vel
    
    state.angular_velocity = clampf(state.angular_velocity,-max_turn_vel,max_turn_vel)
        
    
    
func destroy():
    queue_free()

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("fence") or body.is_in_group("enemy"):
        destroy()
