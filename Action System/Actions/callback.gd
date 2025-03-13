class_name Callback extends Action
##calls function at end of action
var function : Callable

func _end_action():
    if function.is_valid():
        function.call()
    super._end_action()

func _clone():
    var new_action = super._clone()
    new_action.function = function
    return new_action
