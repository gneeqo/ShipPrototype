class_name CamShake extends Action

@export var target_opacity:float

var max_shake:float

func _begin_action():
    if not affected_node is Camera2D:
        print("fade action called on non-CanvasItem")
        breakpoint
    super._begin_action()

func _lerp_value(alpha:float):
    affected_node.shake_intensity = lerp(max_shake,0.0,alpha)
