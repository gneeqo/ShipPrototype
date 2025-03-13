class_name ExecMouseClicked extends Executor

func _process(dt:float):
    if InputProcessor.mouse_just_pressed:
        if paused:
            unpause()
        else:
            triggered = true
    super._process(dt)
    
    

func _clone():
    var new_executor = super._clone()
    return new_executor
