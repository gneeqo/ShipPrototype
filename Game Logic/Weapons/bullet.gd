class_name Bullet extends RigidBody2D

@export var thrust_jerk:float

@export var max_thrust:float
@export var max_vel:float

var curr_thrust:float = 0

var facing_vec: Vector2:
    get:
        return Vector2.from_angle(global_rotation)


func _ready():
    global_rotation = get_parent().global_rotation
    #reparent to scene root
    reparent(get_node("/root/Main"))
    




func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    curr_thrust += thrust_jerk
    clamp(curr_thrust,0,max_thrust)
    
    if state.linear_velocity.length() <max_vel:
     state.apply_central_force(facing_vec*curr_thrust)


func destroy():
    queue_free()
func _on_body_entered(body: Node) -> void:
    if body.is_in_group("fence") or body.is_in_group("enemy"):
        destroy()
