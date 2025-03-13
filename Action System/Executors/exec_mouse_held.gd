class_name ExecMouseHeld extends Executor


func _process(dt:float):
    if InputProcessor.mouse_just_pressed:
        unpause()
    elif not InputProcessor.mouse_down:
        triggered = true
        pause()
    super._process(dt)
    
    
