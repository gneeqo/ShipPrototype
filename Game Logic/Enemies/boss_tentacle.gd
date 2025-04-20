class_name BossTentacle extends Node2D

@export var max_health:int = 1
@export var death_particle : PackedScene 


@onready var health:int = max_health

var invincible = false

signal destroyed

func destroy_enemy():
    var giblets = death_particle.instantiate()
    add_child(giblets)
    for gib in giblets.get_children():
        gib.emitting = true
    
    
    var tree = get_tree()
    
    
    
    add_child(BehaviorFactory.rotate(true,-global_rotation,40))
    add_child(BehaviorFactory.translate(Vector2(1500,1500),150))
    
    destroyed.emit()
    invincible = true   
    
    tree.get_first_node_in_group("camera").begin_shake(1,100) 

func take_damage():
    if invincible:return
    health -=1
    if health <= 0:
        destroy_enemy()  




func _on_collider_body_entered(body: Node2D) -> void:
    if body.is_in_group("player_bullet") or body.is_in_group("player"):
        take_damage()
        var velocity = (PhysicsServer2D.body_get_direct_state(body.get_rid()).linear_velocity)
    if body.is_in_group("player_bullet"):
        body.destroy()
