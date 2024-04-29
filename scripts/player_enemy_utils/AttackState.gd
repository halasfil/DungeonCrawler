class_name AttackState extends Node

func anticipate_and_attack(anticipationAnimationName : String, animationName : String, parent):
	var ANIMATION = parent.ANIMATION
	ANIMATION.play(anticipationAnimationName)
	await get_tree().create_timer(parent.EQUIPPED_WEAPON.weaponAnticipationTime).timeout
	parent.KNOCKBACK = true
	ANIMATION.play(animationName);
