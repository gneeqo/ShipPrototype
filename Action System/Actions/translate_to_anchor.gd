class_name TranslateToAnchor extends Action

@export var drift : float = 0.0

@export var anchor : Node2D



var target_position : Vector2 :
	get:
		return anchor.global_position

var initial_position

var final_target : Vector2
	
func _ready():
		affects_node = true

func _begin_action():
	initial_position = affected_node.position
	if drift != 0:
		var rng = RandomNumberGenerator.new()
		final_target =  Vector2(target_position.x + rng.randf_range(-drift,drift)\
		,target_position.y + rng.randf_range(-drift,drift))
	else:
		final_target = target_position
		


func _lerp_value(alpha:float):
	affected_node.position = lerp(initial_position,final_target,alpha)
	
func _clone():
	var new_action = super._clone()
	new_action.drift = drift
	new_action.anchor = anchor
	return new_action
