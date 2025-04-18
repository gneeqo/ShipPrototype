class_name MissileLauncher extends Weapon



@export var max_cooldown:float = 5.0
@export var num_missles:int = 10
@export var spread:float = 10
@export var firing_time:float = 2
@export var missile_scene: PackedScene

var cooldown:float =0

    
    
func _start_firing():
    if cooldown <=0:
        cooldown = max_cooldown
        for i in num_missles:
            var offset_vec = Vector2(num_missles-i,randf_range(-i,i))
            var rotated_offset = offset_vec.rotated(get_parent().global_rotation)
            
            var fire = Callable(self,"fire_weapon").bind(rotated_offset)
            add_child(BehaviorFactory.delayed_callback(fire,0.1 + i/8.0))
    
    
func _process(delta:float):
    if cooldown > 0:
        cooldown -= delta

func fire_weapon(offset : Vector2):
    var new_missile : Missile = missile_scene.instantiate()
    new_missile.global_position += offset*30
    add_child(new_missile)
