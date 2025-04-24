class_name BehaviorFactory extends Node
##for creating executors via code

static func translate_then_callback(function:Callable,location:Vector2, duration:float , drift:float = 0 ,\
 eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.translate_to(location,duration,eased,ease_type,drift,true),true)
    new_executor.add_child(ActionFactory.callback(function),true)

    return new_executor

static func delayed_callback(function:Callable,duration:float = 0.01 ) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.callback(function,duration),true)

    return new_executor

static func rotate(isClockwise:bool,angle:float, duration:float , drift:float = 0 ,blocking:bool = false,\
 eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.rotate_to(isClockwise,angle,duration,eased,ease_type,drift,blocking),true)
    
    return new_executor

static func fade(opacity:float, duration:float,blocking:bool = false ,\
 eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.fade(opacity,duration,eased,ease_type,blocking),true)
    
    return new_executor

static func translate(location:Vector2, duration:float , drift:float = 0 ,\
 eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.translate_to(location,duration,eased,ease_type,drift,false),true)
    
    return new_executor



static func scale(new_scale:Vector2, duration:float , drift:float = 0,blocking:bool = false ,\
 eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.scale_to(new_scale,duration,eased,ease_type,drift,blocking),true)
    
    return new_executor
    
static func knockback(direction:Vector2, duration:float ,intensity:float, drift:float = 0,blocking:bool = false ,\
 eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.knockback(direction,intensity,duration,eased,ease_type),true)
    
    return new_executor    

    
static func rotational_knockback(duration:float ,intensity:float, drift:float = 0,blocking:bool = false ,\
 eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.rotational_knockback(intensity,duration,eased,ease_type),true)
    
    return new_executor  
    
static func add_delay_to_behavior(delay:float, target:Executor):
    var delayAction = ActionFactory.delay(delay)
    target.add_child(delayAction,true)
    target.move_child(delayAction, 0)
    
static func add_callback_to_behavior(function :Callable, target:Executor):
    var callback = ActionFactory.callback(function)
    target.add_child(callback,true)
    
static func add_action_to_behavior(action :Action, target:Executor):
    target.add_child(action,true)
    
    
static func cam_shake(max_intensity:float, duration:float , drift:float = 0,blocking:bool = false ,\
 eased:bool = true, ease_type:Action.EaseType = Action.EaseType.easeInOutSine) -> Executor:
    var new_executor = ExecAutoActivate.new()
    new_executor.add_child(ActionFactory.cam_shake(max_intensity,duration,eased,ease_type,drift,blocking),true)
    
    return new_executor
