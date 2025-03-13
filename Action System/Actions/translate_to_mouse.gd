class_name TranslateToMouse extends Action

@export var drift : float = 0.0

var initial_position

var mouse_position : Vector2

var final_target : Vector2


func _begin_action():
    initial_position = affected_node.position
    mouse_position = InputProcessor.mouse_pos
    
    if drift != 0:
        var rng = RandomNumberGenerator.new()
        final_target =  Vector2(mouse_position.x + rng.randf_range(-drift,drift)\
        ,mouse_position.y + rng.randf_range(-drift,drift))
    else:
        final_target = mouse_position

func _lerp_value(alpha:float):
    affected_node.position = lerp(initial_position,final_target,alpha)
    
func _clone():
    var new_action = super._clone()
    new_action.drift = drift
    return new_action
