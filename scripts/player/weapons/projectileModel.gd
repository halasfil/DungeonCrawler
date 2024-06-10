class_name ProjectileModel extends Node

var projectileSprite : CompressedTexture2D = preload("res://assets/weapons/arrow.png")
var minDamage : int;
var maxDamage : int;
var weaponPushback : int;
var velocity : float;

func _init(sprite : CompressedTexture2D, min_damage : int, max_damage : int, pushback : int, projectileVelocity : float):
	projectileSprite = sprite
	minDamage = min_damage
	maxDamage = max_damage
	weaponPushback = pushback
	velocity = projectileVelocity
