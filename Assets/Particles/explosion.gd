class_name Explosion extends Node2D

@export var total_lifetime:float
@onready var lifetime = total_lifetime

func _ready():
    for child in get_children():
        if child is CPUParticles2D:
            child.emitting = true

func _process(delta: float) -> void:
    lifetime -= delta
    if lifetime <=0:
        queue_free()
