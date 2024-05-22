extends Area2D
@onready
var ATTACKER = $"../../.."

func _on_body_entered(body):
	deal_damage(body)
	
func deal_damage(receiver):
	if (receiver.has_method("take_damage")):
		receiver.take_damage(
		ATTACKER.EQUIPPED_WEAPON.weaponMinDamage, 
		ATTACKER.EQUIPPED_WEAPON.weaponMaxDamage, 
		ATTACKER.EQUIPPED_WEAPON.weaponPushback,
		ATTACKER
		)
