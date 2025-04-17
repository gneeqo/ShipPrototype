class_name ShipTrackingCamera extends Camera2D

@export var ship : Ship
@export var zoom_factor : float
@export var zoom_max : float
func _process(_delta:float):
    
    if not is_instance_valid(ship):
        return
        
    var body = PhysicsServer2D.body_get_direct_state(ship.get_rid())
    
    if not is_instance_valid(body):
        return
    var ship_speed = body.linear_velocity.length()
    var zoom_amount:float = 1/((1+(ship_speed/zoom_factor)))
    
    if zoom_amount < zoom_max:
        zoom = Vector2(zoom_max,zoom_max)
    else:
        zoom = Vector2(zoom_amount,zoom_amount)
    
    position = ship.position
    
