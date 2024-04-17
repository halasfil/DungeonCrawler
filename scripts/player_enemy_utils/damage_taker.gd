class_name DamageTakerComponent extends Node

func take_damage(min_damage : int, max_damage : int):
	var damage : int = RandomNumberGenerator.new().randi_range(min_damage, max_damage)
	return damage;
