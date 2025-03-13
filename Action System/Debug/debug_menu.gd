class_name DebugMenu extends Control

@export var containers : Array[Container]
@export var containerVMax:int

func add_action_debug(debug :ActionProgress):
    for container in containers:
        if container.get_child_count() < containerVMax:
            container.add_child(debug)
            break
func _process(_delta: float) -> void:
    visible = InputProcessor.debug_menu_open
