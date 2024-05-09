class_name AnimationHelper extends Node

@onready
var ATTACK_STATE : AttackState = $"../AttackState"

func play_idle_animation(parent):
	var ANIMATION = parent.ANIMATION
	if (parent.DIRECTION_FACING == parent.DIRECTIONS.DOWN_R):
		ANIMATION.play("idle_f")
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.DOWN_L):
		ANIMATION.play("idle_f_L")
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.UP_R):
		ANIMATION.play("idle_b")
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.UP_L):
		ANIMATION.play("idle_b_L")

func play_attack_animation(parent):
	var attackType = RandomNumberGenerator.new().randi_range(0, 1)
	if (parent.DIRECTION_FACING == parent.DIRECTIONS.DOWN_R):
		if (attackType == 1):
			ATTACK_STATE.anticipate_and_attack("attack_f_melee_1_anticipation", "attack_f_melee_1", parent)
		else:
			ATTACK_STATE.anticipate_and_attack("attack_f_melee_2_anticipation", "attack_f_melee_2", parent)
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.DOWN_L):
		if (attackType == 1):
			ATTACK_STATE.anticipate_and_attack("attack_f_melee_1_L_anticipation", "attack_f_melee_1_L", parent)
		else:
			ATTACK_STATE.anticipate_and_attack("attack_f_melee_2_L_anticipation", "attack_f_melee_2_L", parent)
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.UP_R):
		if (attackType == 1):
			ATTACK_STATE.anticipate_and_attack("attack_b_melee_1_anticipation", "attack_b_melee_1", parent)
		else:
			ATTACK_STATE.anticipate_and_attack("attack_b_melee_2_anticipation", "attack_b_melee_2", parent)
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.UP_L):
		if (attackType == 1):
			ATTACK_STATE.anticipate_and_attack("attack_b_melee_1_L_anticipation", "attack_b_melee_1_L", parent)
		else:
			ATTACK_STATE.anticipate_and_attack("attack_b_melee_2_L_anticipation", "attack_b_melee_2_L", parent)
			
func play_walking_animation(parent):
	if (parent.DIRECTION_FACING == parent.DIRECTIONS.DOWN_R):
		parent.BODY.flip_h = false
		parent.MELEE.flip_h = false
		parent.ANIMATION.play("run_f")
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.DOWN_L):
		parent.BODY.flip_h = true
		parent.MELEE.flip_h = true
		parent.ANIMATION.play("run_f_L")
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.UP_R):
		parent.BODY.flip_h = false
		parent.MELEE.flip_h = false
		parent.ANIMATION.play("run_b")
	elif (parent.DIRECTION_FACING == parent.DIRECTIONS.UP_L):
		parent.BODY.flip_h = true
		parent.MELEE.flip_h = true
		parent.ANIMATION.play("run_b_L")