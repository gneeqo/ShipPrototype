class_name ShipTrackingCamera extends Camera2D

@export var ship : Ship
@export var zoom_factor : float
@export var zoom_max : float
@export var zoom_min : float
@export var zoom_per_second:float = 0.1
@export var follow_speed:float = 50

var shake_intensity:float
var shake_polarity: int = 1


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
    elif zoom_amount > zoom_min:
        target_zoom = Vector2(zoom_min,zoom_min)
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
    
    position.x += shake_polarity * randf_range(0,shake_intensity)
    position.y += shake_polarity * randf_range(0,shake_intensity)
    
    shake_polarity *= -1
    
    
    #follow_speed = (position - target_position).length() / 50
    #if not (position - target_position).length() <= 6:
        #if position.x < target_position.x:
            #position.x += follow_speed
            #
        #elif position.x > target_position.x:
            #position.x -= follow_speed
            #
        #if position.y < target_position.y:
            #position.y += follow_speed
            #
        #elif position.y > target_position.y:
            #position.y -= follow_speed   
    
    
func begin_shake(duration:float, max_intensity:float):
    add_child(BehaviorFactory.cam_shake(max_intensity,duration,0,false,true,Action.EaseType.easeInOutSine))
    
    
    
