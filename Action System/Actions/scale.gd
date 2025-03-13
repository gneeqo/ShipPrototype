class_name Scale extends Action

@export var target : Vector2

@export var drift: float

var initial_scale : Vector2

var final_scale : Vector2 
        


func _begin_action():
    initial_scale = affected_node.scale
    
    if drift != 0:
        var rng = RandomNumberGenerator.new()
        final_scale =  Vector2(target.x + rng.randf_range(-drift,drift)\
            ,target.y + rng.randf_range(-drift,drift))
    else:
        final_scale = target
    super._begin_action()
    

func _lerp_value(alpha:float):
    affected_node.scale = lerp(initial_scale,final_scale,alpha)

func _clone():
    var new_action = super._clone()
    new_action.target = target
    new_action.drift = drift
    return new_action
