class_name Action extends Node
##Base Action class.

@export_group("Base Action Properties")

##0.0 is infinite duration
@export_range(0,1,0.001,"or_greater","hide_slider") var duration : float

##Does this action stop the execution of others in the list?
@export var blocking : bool

##Does this action repeat itself when it's over?
@export var looping : bool

##Does this action reverse itself when it's over?
@export var oscillating: bool

##Does this action affect a node?
var affects_node : bool = true


@export_subgroup("Easing")
##Does this action use easing?
@export var eased : bool


enum EaseType {easeInSine,easeOutSine,easeInOutSine}
##What easing function does this action use?
@export var ease_type : EaseType

var spawned_by_clone : bool = false

var first_update : bool = true

##How fast does time move for this action?
#TODO: reimplement time scale
var time_scale : float = 1.0 :
    get:
        return 1
##Is this action infinite duration?
var inf : bool :
    get: return duration == 0.0

##Path to the node affected by this action.
var affected_node_path

##The node affected by this action.
var affected_node : Node 





func get_affected_node_by_path():
    return get_node(affected_node_path)


static var ease_functions : Array[Callable] = \
        [func(x:float): return 1 - cos((x * PI) / 2),\
        func(x:float): return sin((x * PI) / 2),\
        func(x:float): return -(cos( x * PI) - 1) / 2,\
        ]

##Is this action currently reversing?
var currently_reversing : bool

##How long this action has been executing for.
##Not the total time, as this will be changed when looping or oscillating.
var elapsed_time : float = 0.0

## elapsed_time / duration, without easing applied.
var linearAlpha : float :
    get:
        if not inf:
            return elapsed_time / duration
        else:
            return 0.0

## linearAlpha with easing applied.
var easedAlpha : float :
    get:
        return ease_functions[ease_type].call(linearAlpha)

##Is this action finished executing?
var isDone : bool :
    get:
        if inf : return false
        if currently_reversing:
            return linearAlpha <= 0.0
        else:
            return linearAlpha >= 1.0

##Is this action ready to be cleaned up?
var should_delete:bool = false


var action_debug:ActionProgress

var debug_menu:DebugMenu

#disable processing, actions are processed only by ActionLists

func _ready():
    set_process_mode(PROCESS_MODE_DISABLED)
    name = get_script().resource_path.get_file()
    

#modify elapsed_time based on delta time
#decrement if reversing, otherwise increment
func update_time(dt:float):
    if currently_reversing:
        decrement_time(dt * time_scale)
    else:
        increment_time(dt * time_scale)

func increment_time(dt:float):
    elapsed_time += dt


func decrement_time(dt:float):
    elapsed_time -= dt

##change whatever value the derived action is intended to change,
## based on provided alpha.
func _lerp_value(_alpha : float):
    pass
        


func reset_action():
    elapsed_time = 0.0
    first_update = true

    
#set up debug
func _begin_action():
    action_debug = load("res://Debug/action_progress.tscn").instantiate()
    action_debug.set_action_name(name)
    action_debug.set_affected_node_name(affected_node.name)
    
    debug_menu = get_node("/root/Root/DebugMenu")
    debug_menu.add_action_debug(action_debug)

##Updsate the action.  Should only be called by [ActionList]
func update_action(dt:float):
    if first_update:
        _begin_action()
        first_update = false
    update_time(dt)
    if eased:
        _lerp_value(easedAlpha)
    else:
        _lerp_value(linearAlpha)
    if is_instance_valid(action_debug):
        action_debug.update_progress( elapsed_time / duration)
    
func _end_action():
    pass
    

##Validate the existence of an affected node, if necessary.
func check_affected_node()->bool:
    if(affected_node == null):
        print("missing affected_node in " + str(get_script().get_path()) )
        return false
    return true

##Validate the flags and variables in this action.
func verify()->bool:
    if affects_node:
        if !spawned_by_clone:
            affected_node = get_affected_node_by_path()
        if(!check_affected_node()):
            return false
    if looping and oscillating:
        return false
    if looping and inf:
        return false
    if oscillating and inf:
        return false
    #flags and variables are valid
    return true
    
    #create a deep copy of this object
func _clone()->Action:
    var newAction : Action = new()
    newAction.duration = duration
    newAction.affects_node = affects_node
    newAction.affected_node_path = affected_node_path
    newAction.affected_node = affected_node
    newAction.blocking = blocking
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.looping = looping
    newAction.time_scale = time_scale
    newAction.currently_reversing = currently_reversing
    
    newAction.spawned_by_clone = true
    
    
    return newAction 

#get rid of debug if action is removed due to reloading
func _exit_tree ():
    if is_instance_valid(action_debug):
        action_debug.queue_free()
