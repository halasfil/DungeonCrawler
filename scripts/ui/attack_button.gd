class_name AttackButton extends Node2D

var pressed : bool;

func _on_touch_screen_button_pressed():
	pressed = true

func _on_touch_screen_button_released():
	pressed = false
