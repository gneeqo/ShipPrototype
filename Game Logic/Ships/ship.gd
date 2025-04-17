class_name Ship extends RigidBody2D

@export var thrust_jerk:float
@export var decel_jerk:float
@export var max_thrust:float
@export var max_vel:float

@export var turn_jerk:float
@export var turn_decel_jerk:float
@export var max_turn_accel:float
@export var max_turn_vel:float

@export var weapon_1: Weapon

#for telemetry purposes
@export var classification:int

var time_last_telemetry_sent : float

var linear_decel_active:bool = false
var angular_decel_active:bool = false


var facing_vec: Vector2:
    get:
        return Vector2.from_angle(global_rotation)

var this_frame_thrust_vec:Vector2
var prev_frame_thrust_vec:Vector2
var delta_thrust_vec:
    get:
        return this_frame_thrust_vec - prev_frame_thrust_vec

var this_frame_torque:float
var prev_frame_torque:float
var delta_torque:
    get:
        return this_frame_torque - prev_frame_torque

var curr_thrust_accel:float
var curr_turn_accel:float

var ship_inertia:float:
    get:
        return 1.0 / PhysicsServer2D.body_get_direct_state(get_rid()).inverse_inertia



func _ready():
    if ShipTelemetry.telemetry_active:
        ShipTelemetry.new_ship_instance(self)
        time_last_telemetry_sent = Time.get_unix_time_from_system()

func process_input()->void:
    #accel or decel
    if Input.is_action_pressed("accelerate"):
        curr_thrust_accel += thrust_jerk
        linear_decel_active = false
    elif Input.is_action_pressed("decelerate"):
        curr_thrust_accel -= decel_jerk
        linear_decel_active = true
    else:
        curr_thrust_accel = 0
        linear_decel_active = false
    
    #turn left or right
    if Input.is_action_pressed("turn_left"):
        if sign(prev_frame_torque) == 1:
            curr_turn_accel -= turn_decel_jerk
            angular_decel_active = true
        else:
            curr_turn_accel -= turn_jerk
            angular_decel_active = false
    elif Input.is_action_pressed("turn_right"):
        if sign(prev_frame_torque) == -1:
            angular_decel_active = true
            curr_turn_accel += turn_decel_jerk
        else:
            angular_decel_active = false
            curr_turn_accel += turn_jerk
    else:
        curr_turn_accel = 0
        angular_decel_active = false
        
    #fire chaingun
    if Input.is_action_just_pressed("fire_weapon_1"):
        weapon_1._start_firing()
    if Input.is_action_just_released("fire_weapon_1"):
        weapon_1._stop_firing()
    
    prev_frame_thrust_vec = this_frame_thrust_vec
    this_frame_thrust_vec = facing_vec * mass * curr_thrust_accel
    
    prev_frame_torque = this_frame_torque
    this_frame_torque = curr_turn_accel * ship_inertia    
        
    

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    process_input()
    state.apply_central_force(this_frame_thrust_vec)
    state.apply_torque(this_frame_torque)
    send_telemetry()
        
 
func kill():
    #respawn, etc.
    ShipTelemetry.add_event("Ship","Died","")
    ShipTelemetry.refresh_telemetry()
    queue_free()

func send_telemetry():
    if not ShipTelemetry.telemetry_active:
        return
    if Time.get_unix_time_from_system() - time_last_telemetry_sent > 0.2:
        time_last_telemetry_sent = Time.get_unix_time_from_system()
        var physics_body = PhysicsServer2D.body_get_direct_state(get_rid())
        
        ShipTelemetry.add_event("Linear Velocity",str(physics_body.linear_velocity.x),str(physics_body.linear_velocity.y))
        ShipTelemetry.add_event("Linear Velocity Magnitude",str(physics_body.linear_velocity.length()),"")
        ShipTelemetry.add_event("Linear Acceleration",str(curr_thrust_accel),"")
        
        if linear_decel_active:
            ShipTelemetry.add_event("Linear Jerk",str(decel_jerk),"")
        else:
            ShipTelemetry.add_event("Linear Jerk",str(thrust_jerk),"")
        
       
        ShipTelemetry.add_event("Angular Velocity",str(physics_body.angular_velocity),"")
        ShipTelemetry.add_event("Angular Acceleration",str(curr_turn_accel),"")
        
        if linear_decel_active:
            ShipTelemetry.add_event("Angular Jerk",str(turn_decel_jerk),"")
        else:
            ShipTelemetry.add_event("Angular Jerk",str(turn_jerk),"")
     
