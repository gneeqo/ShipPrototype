class_name Fade extends Action

@export var target_opacity:float

var initial_opacity:float

func _begin_action():
    if affected_node is CanvasItem:
        initial_opacity = affected_node.modulate.a
    else:
        print("fade action called on non-CanvasItem")
        breakpoint
    super._begin_action()

func _lerp_value(alpha:float):
    affected_node.modulate.a = lerp(initial_opacity,target_opacity,alpha)
