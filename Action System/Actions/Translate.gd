class_name Translate extends Action


@export var target : Vector2
@export var drift : float = 0.0

var initial_position

var final_target : Vector2 
        

func _begin_action():
    initial_position = affected_node.global_position
    if drift != 0:
            var rng = RandomNumberGenerator.new()
            final_target = Vector2(target.x + rng.randf_range(-drift,drift)\
            ,target.y + rng.randf_range(-drift,drift))
    else: final_target =  target
    super._begin_action()

func _lerp_value(alpha:float):
    affected_node.global_position = lerp(initial_position,final_target,alpha)

func _clone():
    var new_action = super._clone()
    new_action.target = target	
    new_action.drift = drift
    return new_action
