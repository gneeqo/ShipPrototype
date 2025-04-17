class_name referee extends Node

@export var ship_types : Array[PackedScene]
@export var Camera : ShipTrackingCamera

var player_ship: Ship
var player_ship_type: int = 0

func _ready():
    spawn_ship()

func spawn_ship():
    player_ship = ship_types[player_ship_type].instantiate()
    get_parent().add_child.call_deferred(player_ship)
    Camera.ship = player_ship
    
    
func destroy_ship():
    player_ship.kill()

func _process(dt:float):
    if Input.is_action_just_pressed("switch_ship_1"):
        destroy_ship()
        player_ship_type = 0
        spawn_ship()
    elif Input.is_action_just_pressed("switch_ship_2"):
        destroy_ship()
        player_ship_type = 1
        spawn_ship()
    elif Input.is_action_just_pressed("switch_ship_3"):
        destroy_ship()
        player_ship_type = 2
        spawn_ship()
