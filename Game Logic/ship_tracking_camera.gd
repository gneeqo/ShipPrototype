class_name ShipTrackingCamera extends Camera2D

@export var ship : Ship
@export var zoom_factor : float
@export var zoom_max : float
@export var zoom_per_second:float = 0.1
@export var follow_speed:float = 50


var target_zoom
var target_position

func _process(_delta:float):
    
    if not is_instance_valid(ship):
        return
        
    var body = PhysicsServer2D.body_get_direct_state(ship.get_rid())
    
    if not is_instance_valid(body):
        return
    
    var ship_speed = body.linear_velocity.length()
    
    var zoom_amount:float = 1/((1+(ship_speed/zoom_factor)))
    
    if zoom_amount < zoom_max:
        target_zoom = Vector2(zoom_max,zoom_max)
    else:
        target_zoom = Vector2(zoom_amount,zoom_amount)
    
    if zoom < target_zoom:
        zoom.x += zoom_per_second
        zoom.y += zoom_per_second
    elif zoom > target_zoom:
        zoom.x -= zoom_per_second
        zoom.y -= zoom_per_second
    
    if (zoom - target_zoom).length() < 0.5:
        zoom = target_zoom
    
    
    
    position = ship.position
    
    
        
    
    
