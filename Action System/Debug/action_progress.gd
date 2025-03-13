class_name ActionProgress extends ProgressBar

@export var affected_node_name : RichTextLabel
@export var action_name : RichTextLabel


func set_affected_node_name(_name: String):
    affected_node_name.text = _name

func set_action_name(_name: String):
    action_name.text = _name

func update_progress(percent : float):
    value = percent
    if value >= 1:
        queue_free()
