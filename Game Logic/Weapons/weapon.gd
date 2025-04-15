class_name Weapon extends Node

var is_firing:bool = false

func _start_firing():
    is_firing = true
    
func _stop_firing():
    is_firing = false
