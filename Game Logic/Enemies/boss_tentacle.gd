class_name BossTentacle extends Node2D

@export var max_health:int = 1
@export var death_particle : PackedScene 


@onready var health:int = max_health

@export var hit_effect : CPUParticles2D

@export var weapon:EnemyGun

var invincible = false

signal destroyed

func destroy_enemy():
    var giblets = death_particle.instantiate()
    add_child(giblets)
    for gib in giblets.get_children():
        gib.emitting = true
    
    
    var tree = get_tree()
    
    call_deferred("parent_to_root")
    
    
    
    add_child(BehaviorFactory.rotate(true,-global_rotation,75))
    add_child(BehaviorFactory.translate(Vector2(1500,1500),25))
    
    destroyed.emit()
    invincible = true   
    
    tree.get_first_node_in_group("camera").begin_shake(1,250)
    
    weapon.queue_free()
    
    
   
func parent_to_root():
    
    
    var main = get_node("/root/Main")
    reparent(main)
    
    show_behind_parent = false
    
    
    
 
func take_damage():
    if invincible:return
    health -=1
    if health <= 0:
        destroy_enemy()  
        get_tree().get_first_node_in_group("hud").PostBigText("Boss Part Destroyed",1) 




func _on_collider_body_entered(body: Node2D) -> void:
    if body.is_in_group("player_bullet") or body.is_in_group("player"):
        take_damage()
        if is_instance_valid(hit_effect):
            hit_effect.global_position = body.global_position
            hit_effect.emitting = true
    if body.is_in_group("player_bullet"):
        body.destroy()
        
