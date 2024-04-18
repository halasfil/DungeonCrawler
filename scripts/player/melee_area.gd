extends Area2D
@onready
var PLAYER_NODE : Player = $"../../.."

func _on_body_entered(body):
	if (!(body is Player) && body.has_method("take_damage")):
		body.take_damage(
		PLAYER_NODE.EQUIPPED_WEAPON.weaponMinDamage, 
		PLAYER_NODE.EQUIPPED_WEAPON.weaponMaxDamage, 
		PLAYER_NODE.EQUIPPED_WEAPON.weaponPushback)
