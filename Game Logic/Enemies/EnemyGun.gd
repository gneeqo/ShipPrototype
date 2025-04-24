class_name EnemyGun extends Node2D

@export var projectile:PackedScene
@export var projectiles_per_salvo:int
@export var salvo_spread:float

@export var max_firing_interval:float
@onready var firing_interval = max_firing_interval

@export var bullet_target : Node2D


func spawn_projectile(location:Vector2):
    
    var new_bullet:RigidBody2D = projectile.instantiate()
    get_parent().get_parent().add_child(new_bullet)
    
    
    var ship = get_tree().get_first_node_in_group("referee").player_ship
    
    if is_instance_valid(ship):
        new_bullet.global_rotation = new_bullet.get_angle_to(bullet_target.global_position)
    
    new_bullet.global_position = global_position +location
    
   

func fire_salvo():
    for i in projectiles_per_salvo:
            var offset_vec = Vector2((projectiles_per_salvo-i)*salvo_spread,randf_range(-i,i)*salvo_spread)
            var rotated_offset = offset_vec.rotated(get_parent().global_rotation)
            
            var fire = Callable(self,"spawn_projectile").bind(rotated_offset)
            add_child(BehaviorFactory.delayed_callback(fire,0.1 + i/8.0))

func _process(delta: float) -> void:
    firing_interval -= delta
    if firing_interval <= 0:
        firing_interval = max_firing_interval
        fire_salvo() 
