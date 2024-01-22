class_name InventoryButton extends Node2D

var pressed : bool = false

func _on_button_button_down():
	pressed = true

func _on_button_button_up():
	pressed = false
