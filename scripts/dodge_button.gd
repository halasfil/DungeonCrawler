class_name DodgeButton extends Node2D

var pressed : bool;

func _on_touch_screen_button_pressed() -> void:
	pressed = true

func _on_touch_screen_button_released() -> void:
	pressed = false
