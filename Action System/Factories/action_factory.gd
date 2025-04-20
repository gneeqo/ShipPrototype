class_name ActionFactory extends Node
##for creating actions via code


static func translate_to(location:Vector2,duration:float,\
eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine,\
 drift:float = 0 ,blocking:bool = false,looping:bool = false, oscillating:bool = false)->Translate:
    var newAction = Translate.new()
    
    newAction.target = location
    newAction.drift = drift
    newAction.duration = duration
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.blocking = blocking
    newAction.looping = looping
    newAction.oscillating = oscillating
    
    
    return newAction

static func rotate_to(angle:float,duration:float,\
eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine,\
 drift:float = 0 ,blocking:bool = false,looping:bool = false, oscillating:bool = false)->Rotate:
    var newAction = Rotate.new()
    
    newAction.target_angle = angle
    newAction.drift = drift
    newAction.duration = duration
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.blocking = blocking
    newAction.looping = looping
    newAction.oscillating = oscillating
    
    
    return newAction
    
static func fade(opacity:float,duration:float,\
eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine,\
  blocking:bool = false,looping:bool = false, oscillating:bool = false)->Fade:
    var newAction = Fade.new()
    
    newAction.target_opacity = opacity
    
    newAction.duration = duration
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.blocking = blocking
    newAction.looping = looping
    newAction.oscillating = oscillating
    
    
    return newAction
    
    
static func cam_shake(max_intensity:float,duration:float,\
eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine,\
  blocking:bool = false,looping:bool = false, oscillating:bool = false)->CamShake:
    var newAction = CamShake.new()
    
    newAction.max_shake = max_intensity
    
    newAction.duration = duration
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.blocking = blocking
    newAction.looping = looping
    newAction.oscillating = oscillating
    
    
    return newAction

static func scale_to(scale:Vector2,duration:float,\
eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine,\
 drift:float = 0 ,blocking:bool = false,looping:bool = false, oscillating:bool = false)->Scale:
    var newAction = Scale.new()
    
    newAction.target = scale
    newAction.drift = drift
    newAction.duration = duration
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.blocking = blocking
    newAction.looping = looping
    newAction.oscillating = oscillating
    
    
    return newAction

static func callback(function:Callable,duration:float = 0.01,\
eased:bool = false, ease_type:Action.EaseType = Action.EaseType.easeInOutSine,\
 blocking:bool = false,looping:bool = false, oscillating:bool = false)->Callback:
    var newAction = Callback.new()
    
    newAction.function = function

    newAction.duration = duration
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.blocking = blocking
    newAction.looping = looping
    newAction.oscillating = oscillating
    
    
    return newAction

static func delay(duration:float=0.01):
    var newAction = Action.new()
    newAction.duration = duration
    newAction.blocking = true
    return newAction
    
static func knockback(direction:Vector2,intensity:float,duration:float = 0.01,\
eased:bool = false, ease_type:Action.EaseType = Action.EaseType.easeInOutSine,\
 blocking:bool = false,looping:bool = false, oscillating:bool = false)->Knockback:
    var newAction = Knockback.new()
    
    newAction.direction = direction
    newAction.intensity = intensity
    
    newAction.duration = duration
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.blocking = blocking
    newAction.looping = looping
    newAction.oscillating = oscillating
    
    
    return newAction


static func rotational_knockback(intensity:float,duration:float = 0.01,\
eased:bool = false, ease_type:Action.EaseType = Action.EaseType.easeInOutSine,\
 blocking:bool = false,looping:bool = false, oscillating:bool = false)->RotationalKnockback:
    var newAction = RotationalKnockback.new()
    
   
    newAction.intensity = intensity
    
    newAction.duration = duration
    newAction.eased = eased
    newAction.ease_type = ease_type
    newAction.blocking = blocking
    newAction.looping = looping
    newAction.oscillating = oscillating
    
    
    return newAction
