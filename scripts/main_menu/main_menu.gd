extends Node
@onready
var scene = "res://scenes/main_game/game.tscn"
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file(scene)

func _on_exit_button_pressed():
	get_tree().quit();
