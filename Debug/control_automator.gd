class_name ControlAutomator extends Node

var action_names : Array[StringName]

var is_automating : bool = false

var time_since_last_automation_trigger:float = 6.0

var max_automation_trigger_duration:float = 0.5

var random : RandomNumberGenerator
var ref:referee

#input actions that the automator should not use.
var excluded_actions : Array[String]\
=["toggle_automation",\
"escape",\
"switch_ship_1",\
"switch_ship_2",\
"switch_ship_3",
"invincible"]

func _ready():
    action_names = InputMap.get_actions()
    random = RandomNumberGenerator.new()
    random.randomize()
    ref = get_tree().get_first_node_in_group("referee")
    
    

func press_action(action_name : StringName):
    Input.action_press(action_name)
    
func release_action(action_name : StringName):
    Input.action_release(action_name)
    
func press_and_hold(action_name:StringName,duration:float):
    press_action(action_name)
    add_child(BehaviorFactory.delayed_callback(Callable(self,"release_action").bind(action_name),duration))

func _process(dt:float):
    if Input.is_action_just_pressed("toggle_automation"):
        is_automating = !is_automating
        if is_automating:
            ShipTelemetry.start_collecting()
            ShipTelemetry.add_event("Telemetry","Started","Manually")
        else:
            ShipTelemetry.add_event("Telemetry","Ended","Manually")
            ShipTelemetry.finish_collecting()
    
    if is_automating:
        if time_since_last_automation_trigger > max_automation_trigger_duration:
            time_since_last_automation_trigger = 0
            basic_ship_behavior()
        else:
            time_since_last_automation_trigger += dt
        
        
        



func basic_ship_behavior():
    if ref.bossSpawned:
        attack_run()
    else:
        do_all_actions_random()
   
#testing automation functionality. 
func do_all_actions_random():
    for action in action_names:
        if excluded_actions.has(action):
            pass
        else:
            if random.randi_range(0,1):
                press_and_hold(action,random.randf_range(0,max_automation_trigger_duration))
    

#do the action for one second.
func turn_right():
    press_and_hold("turn_right",0.5)
func turn_left():
    press_and_hold("turn_left",0.5)
func accelerate():
    press_and_hold("accelerate",1)
func decelerate():
    press_and_hold("decelerate",1)
func fire_1():
    press_and_hold("fire_weapon_1",1)
func fire_2():
    press_and_hold("fire_weapon_2",1)


func attack_run():
    var boss = get_tree().get_first_node_in_group("Boss")
    var ship = ref.player_ship
    
    if not is_instance_valid(ship) or not is_instance_valid(boss):
        return
    var distance = abs(boss.global_position.x - ship.global_position.x)
    var distance2 = abs(boss.global_position.y - ship.global_position.y)
    if( distance> 1500 or distance2> 1500):
        accel_past_boss()
    else:
        if distance < 300 and distance2 < 300:
            retreat()
        else:
            face_boss_and_attack()
                

func face_boss_and_attack():
    var boss = get_tree().get_first_node_in_group("Boss")
    var ship = ref.player_ship
    
    if not is_instance_valid(ship) or not is_instance_valid(boss):
        return
    
    
    
    var current_facing: Vector2 = Vector2.from_angle(ship.global_rotation)
    var facing_toward_target:Vector2 = (boss.global_position - ship.global_position).normalized()
    var angle_diff = asin(current_facing.cross(facing_toward_target) /(abs(current_facing).dot(abs(facing_toward_target))))
    
    if angle_diff > 0:
        turn_right()
    elif angle_diff <0:
        turn_left()  
        
    fire_1()
    fire_2()


@export var retreat_distance:float = 1500

func retreat():
    var boss = get_tree().get_first_node_in_group("Boss")
    var ship = ref.player_ship
    
    if not is_instance_valid(ship) or not is_instance_valid(boss):
        return
    
    var target = boss.global_position
    
    
    if ship.global_position.x > target.x:
         if ship.global_position.y > target.y:
             target+= Vector2(1,1)*retreat_distance
         else:
            target+= Vector2(1, -1)*retreat_distance
    else:
        if ship.global_position.y > target.y:
             target+= Vector2(-1, 1)*retreat_distance
        else:
            target+= Vector2(-1, -1)*retreat_distance
 
    var current_facing: Vector2 = Vector2.from_angle(ship.global_rotation)
    var facing_toward_target:Vector2 = (target - ship.global_position).normalized()
    var angle_diff = asin(current_facing.cross(facing_toward_target) /(abs(current_facing).dot(abs(facing_toward_target))))
    
    if angle_diff > 0:
        turn_right()
    elif angle_diff <0:
        turn_left()  
    accelerate()


@export  var strafe_distance:float = 750
func accel_past_boss():
    var boss = get_tree().get_first_node_in_group("Boss")
    var ship = ref.player_ship
    
    if not is_instance_valid(ship) or not is_instance_valid(boss):
        return
    
    var target = boss.global_position
    
    
    if ship.global_position.x > target.x:
         if ship.global_position.y > target.y:
            #we are to the top right, so we should go to the bottom right.
             target+= Vector2(1, -1)* strafe_distance
         else:
            #we are to the bottom right, so we should go to the top right.
            target+= Vector2(1, 1)*strafe_distance
    else:
        if ship.global_position.y > target.y:
            #we are to the top left, so we should go to the bottom left.
             target+= Vector2(-1, -1)*strafe_distance
        else:
            #we are to the bottom left, so we should go to the top left.
            target+= Vector2(1, -1)*strafe_distance
 
    var current_facing: Vector2 = Vector2.from_angle(ship.global_rotation)
    var facing_toward_target:Vector2 = (target - ship.global_position).normalized()
    var angle_diff = asin(current_facing.cross(facing_toward_target) /(abs(current_facing).dot(abs(facing_toward_target))))
    
    if angle_diff > 0:
        turn_right()
    elif angle_diff <0:
        turn_left()  
    accelerate()
