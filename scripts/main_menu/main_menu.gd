extends Node

@onready
var GAME_SCENE = "res://scenes/game.tscn";

func _on_start_button_pressed():
	get_tree().change_scene_to_file(GAME_SCENE);

func _on_exit_button_pressed():
	get_tree().quit();
