class_name BaseEnemy extends RigidBody2D

func kill():
    queue_free()


func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player_bullet"):
        kill()
