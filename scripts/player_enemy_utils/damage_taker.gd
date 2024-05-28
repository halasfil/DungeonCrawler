class_name DamageTakerComponent extends Node

func calculate_damage(min_damage: int, max_damage: int):
	var randomizer: RandomNumberGenerator = RandomNumberGenerator.new()
	randomizer.randomize()
	var damage: int = randomizer.randi_range(min_damage, max_damage)
	return damage;
