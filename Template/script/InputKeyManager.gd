extends Node

var shift_pressed := false
var ctrl_pressed := false
var alt_pressed := false

func _input(event):
    if event is InputEventKey:
        match event.keycode:
            KEY_SHIFT:
                shift_pressed = event.pressed
            KEY_CTRL:
                ctrl_pressed = event.pressed
            KEY_ALT:
                alt_pressed = event.pressed