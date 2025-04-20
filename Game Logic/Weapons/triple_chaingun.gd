class_name TripleChaingun extends Weapon


@export var guns : Array[Weapon]





func _start_firing():
    is_firing = true
    for gun in guns:
        gun._start_firing()
    
func _stop_firing():
    is_firing = false
    for gun in guns:
        gun._stop_firing()


    
