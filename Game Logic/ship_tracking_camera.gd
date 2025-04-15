extends Camera2D

@export var ship : Ship
@export var zoom_factor : float
@export var zoom_max : float
func _process(_delta:float):
    var ship_speed = \
    PhysicsServer2D.body_get_direct_state(ship.get_rid()).linear_velocity.length()
    var zoom_amount:float = 1/((1+(ship_speed/zoom_factor)))
    
    if zoom_amount < zoom_max:
        zoom = Vector2(zoom_max,zoom_max)
    else:
        zoom = Vector2(zoom_amount,zoom_amount)
    
    position = ship.position
    
