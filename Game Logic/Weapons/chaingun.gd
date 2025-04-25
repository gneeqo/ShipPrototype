class_name chain_gun extends Weapon

@export var fire_rate_accel : float = 1
@export var fire_rate_decel : float = 1
@export var max_fire_rate : float = 10
@export var bullet_scene : PackedScene
@export var kick_strength : float = 1
var loaded_bullet:Bullet


var curr_fire_rate:float

var kick_direction:int = -1

var percent_of_second_to_fire:float:
    get:
        return 1.0 / curr_fire_rate

var accumulated_delta:float = 0
var firing_delta:float = 0



func _process(delta:float)->void:
    firing_delta += delta
    accumulated_delta += delta
    #every second, increase or decrease fire rate.
    if(accumulated_delta >=1):
        if is_firing:
            curr_fire_rate += fire_rate_accel
            if curr_fire_rate > max_fire_rate:
                curr_fire_rate = max_fire_rate
        else:
            curr_fire_rate -= fire_rate_decel
            if curr_fire_rate < 0:
                curr_fire_rate = 0
        accumulated_delta = 0
    if curr_fire_rate >0:
        #enough time has passed to fire another shot
        if(firing_delta >= percent_of_second_to_fire):
            fire_weapon()
            firing_delta = 0
    
    

func fire_weapon():
    var new_bullet : Bullet = bullet_scene.instantiate()
    add_child(new_bullet)
    new_bullet.linear_velocity = get_parent().linear_velocity
    get_parent().take_knockback(-Vector2.from_angle(get_parent().global_rotation\
    + randf_range(-curr_fire_rate,curr_fire_rate)),2)
    get_parent().take_rotational_knockback(kick_strength*curr_fire_rate * kick_direction)
    kick_direction = kick_direction * -1
    
