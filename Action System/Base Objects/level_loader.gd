class_name LevelLoader extends Node
##manages loading and unloading levels, and bringing up the menu


@export var level_scenes : Array[PackedScene]
@export var main_menu : PackedScene
@export var game_over : PackedScene
@export var transitions_in : Array[PackedScene]
@export var transitions_out:Array[PackedScene]

var prev_level_root : Node
var active_level_root : Node
var menu_node : Node
var menu_done_moving:bool = true
var menu_active : bool = false
var level_done_loading : bool = true

var current_level_index : int = 0

enum TransitionType{SLIDE_LEFT,SLIDE_RIGHT,FADE,SHRINK}

var curr_transition : TransitionType


    
func _ready():
    var start_level = level_scenes[0].instantiate()
    #have to call_deferred here because not all the other nodes are set up yet
    get_tree().root.add_child.call_deferred(start_level,true)
    active_level_root = start_level
    
func _process(_dt:float)->void:
    pass

func load_scene_at_index(index:int):
    if level_done_loading and menu_done_moving:
        #we're not in a transition state, so we can load the new level
        prev_level_root = active_level_root
        active_level_root = level_scenes[index].instantiate()
        active_level_root.modulate.a = 0
        
        get_tree().root.add_child(active_level_root,true)
        
        level_done_loading = false
        
        current_level_index = index
        
        
        
        intro_scene(active_level_root)
        dispose_scene(prev_level_root)
        
        TelemetryCollector.add_event("LevelLoader","Started Loading",active_level_root.name)

func set_menu_done_moving():
    menu_done_moving = true
    
func set_menu_done_moving_and_unpause():
    menu_done_moving = true
    GlobalExecutorList.unpause_world_executors()

func set_level_done_loading():
    level_done_loading = true
    TelemetryCollector.add_event("LevelLoader","Finished Loading",active_level_root.name)



func load_main_menu():
    #example of action list not set up by code but set up in editor instead.
    #too inflexible to use larger scale
    var behavior = transitions_in[curr_transition].instantiate()
    #let us know when the action is done
    behavior.provide_callback(Callable(self,"set_menu_done_moving"))
    
    
    menu_node = main_menu.instantiate()
    #set initial opacity to 0 to stop flickering
    menu_node.modulate.a = 0
    
    get_tree().root.add_child(menu_node,true)
    
    
    menu_node.add_child(behavior,true)
    menu_active = true
    menu_done_moving = false
    
    #pause world space actions
    GlobalExecutorList.pause_world_executors()

func load_game_over():
    #exact same as menu load but uses the game over scene
    
    #example of action list not set up by code but set up in editor instead.
    #too inflexible to use larger scale
    var behavior = transitions_in[curr_transition].instantiate()
    #let us know when the action is done
    behavior.provide_callback(Callable(self,"set_menu_done_moving"))
    
    
    menu_node = game_over.instantiate()
    #set initial opacity to 0 to stop flickering
    menu_node.modulate.a = 0
    get_tree().root.add_child(menu_node,true)
    
    
    menu_node.add_child(behavior,true)
    menu_active = true
    menu_done_moving = false
    
    #pause world space actions
    GlobalExecutorList.pause_world_executors()



func dispose_main_menu():
    #move the menu offscreen
    var behavior = transitions_out[curr_transition].instantiate()
    behavior.provide_callback(Callable(self,"set_menu_done_moving_and_unpause"))
    menu_active = false
    menu_done_moving = false
    menu_node.add_child(behavior,true)



func intro_scene(scene:Node2D):
    #move level onscreen
    var behavior = transitions_in[curr_transition].instantiate()
    behavior.provide_callback(Callable(self,"set_level_done_loading"))
    
    
    
    scene.add_child(behavior,true)

func dispose_scene(scene:Node2D):
    #move level offscreen
    var behavior = transitions_out[curr_transition].instantiate()
    scene.add_child(behavior,true)
