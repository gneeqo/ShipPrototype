class_name Knockback extends Action

@export var intensity:float

@export var direction:Vector2
func _begin_action():
    if affected_node is Ship or affected_node.is_in_group("enemy"):
        affected_node.add_to_knockback(direction*intensity)
    else:
        print("knockback action called on wrong object")
        breakpoint
    super._begin_action()

func _lerp_value(alpha:float):
    affected_node.add_to_knockback(direction*lerp(intensity,0.0,alpha))
