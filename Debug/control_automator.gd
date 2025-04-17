class_name ControlAutomator extends Node

var action_names : Array[StringName]

var is_automating : bool = false

var time_since_last_automation_trigger:float = 6.0

var max_automation_trigger_duration:float = 5.0

var random : RandomNumberGenerator

#input actions that the automator should not use.
var excluded_actions : Array[String]\
=["toggle_automation",\
"escape",\
"switch_ship_1",\
"switch_ship_2",\
"switch_ship_3"]

func _ready():
    action_names = InputMap.get_actions()
    random = RandomNumberGenerator.new()
    random.randomize()
    

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
    do_all_actions_random()
    
func do_all_actions_random():
    for action in action_names:
        if action == "toggle_automation" or action == "escape":
            pass
        else:
            if random.randi_range(0,1):
                press_and_hold(action,random.randf_range(0,max_automation_trigger_duration))
            
