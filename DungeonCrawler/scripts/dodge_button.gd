extends Node2D

var pressed : bool;

func _on_touch_screen_button_pressed() -> void:
	print("dodge")
	pressed = true

func _on_touch_screen_button_released() -> void:
	pressed = false
