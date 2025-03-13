class_name ExecCollide extends Executor

@export var continue_until_exit : bool = false

func initialize_by_parent():
    super.initialize_by_parent()
    if get_parent() is Area2D:
        get_parent().area_entered.connect(on_area_entered)
        get_parent().area_exited.connect(on_area_exited)
    else:
        breakpoint

func initialize_by_clone():
    super.initialize_by_clone()
    if get_parent() is Area2D:
        get_parent().area_entered.connect(on_area_entered)
    else:
        breakpoint


func on_area_entered(_other:Area2D):
    unpause()

func on_area_exited(_other:Area2D):
    pause()
    triggered = true


func _clone():
    var new_executor = super._clone()
    return new_executor
        
    
