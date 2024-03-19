class_name BasicEnemyParentResource extends Node

var body_sprite : Array[CompressedTexture2D];
var melee_sprite : Array[CompressedTexture2D];
var ranged_sprite : Array[CompressedTexture2D];
var ranged : bool;
var rangedWeapon : bool;
var meleeWeapon : bool;
var run_in_fear_probability : float;
var health : int;
var moving_speed : int;
var before_attack_emancipation_time : float;
var max_gold_loot : int;
var max_health_loot : int;
var attack_max : int;
var attack_min : int;
var protection_max : int;
var protection_min : int;

func _init():
	#todo
	pass
