extends Node

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn");

func _on_exit_button_pressed():
	get_tree().quit();
