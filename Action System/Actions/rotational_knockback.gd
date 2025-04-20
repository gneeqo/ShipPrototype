class_name RotationalKnockback extends Action

@export var intensity:float


func _begin_action():
    if affected_node is Ship or affected_node is BaseEnemy:
        affected_node.add_to_rotational_knockback(intensity)
    else:
        print("knockback action called on wrong object")
        breakpoint
    super._begin_action()

func _lerp_value(alpha:float):
    affected_node.add_to_rotational_knockback(lerp(intensity,0.0,alpha))
