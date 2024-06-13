class_name DropHelper extends Node

func spawn_drop(type, ammount, strength):
	pass
	#var randomizer: RandomNumberGenerator = RandomNumberGenerator.new()
	#randomizer.randomize()
	#if type == Drop.DROP_TYPES.COIN:
		#var spawn : int = randomizer.randi_range(0, ammount)
		#for i in range(spawn):
			#var DROP_SCENE : PackedScene = preload("res://scenes/drop_items/Drop.tscn")
			#var DROP : Drop = DROP_SCENE.instantiate()
			#get_parent().add_child(DROP)
			#DROP.TYPE = Drop.DROP_TYPES.COIN
			#DROP.STRENGTH = strength
			##todo position
	#elif type == Drop.DROP_TYPES.HEALTH:
		#var spawn : int = randomizer.randi_range(0, ammount)
		#for i in range(spawn):
			#var DROP_SCENE : PackedScene = preload("res://scenes/drop_items/Drop.tscn")
			#var DROP : Drop = DROP_SCENE.instantiate()
			#get_parent().add_child(DROP)
			#DROP.TYPE = Drop.DROP_TYPES.HEALTH
			#DROP.STRENGTH = strength
			#todo position

