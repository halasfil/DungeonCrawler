class_name ProjectileHelper extends Node

func shoot_projectile(
	spawnPosition : Vector2, 
	rotation : float, 
	projectileModel : ProjectileModel, 
	spawnerPosition : Vector2,
	parent : Node):
	var PROJECTILE_SCENE : PackedScene = preload("res://scenes/player/projectile.tscn")
	var projectile : Projectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = spawnPosition
	projectile.rotation = rotation
	projectile.PROJECTILE = projectileModel
	projectile.SHOOTER = parent
	var aimPositon : Vector2 = spawnPosition
	var shootAngle : Vector2 = (aimPositon - spawnerPosition).normalized()
	projectile.velocity =  shootAngle * 3 * projectileModel.velocity
