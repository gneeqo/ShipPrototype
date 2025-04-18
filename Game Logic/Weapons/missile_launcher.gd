class_name MissileLauncher extends Weapon


@export var fire_rate_accel : float = 1
@export var fire_rate_decel : float = 1
@export var max_fire_rate : float = 10
@export var missile_scene : PackedScene

var loaded_bullet:Missile


var curr_fire_rate:float


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
    var new_missile : Missile = missile_scene.instantiate()
    add_child(new_missile)
