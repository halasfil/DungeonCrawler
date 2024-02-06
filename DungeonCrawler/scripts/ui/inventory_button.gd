class_name InventoryButton extends Node2D

var pressed : bool = false

func _on_button_pressed():
	pressed = true


func _on_button_released():
	pressed = false
