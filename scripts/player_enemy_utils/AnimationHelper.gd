class_name AnimationHelper extends Node

@onready
var STATES_AND_HELPERS : StatesAndHelpers = $".."
@onready
var ATTACK_STATE : AttackState = $"../AttackState"

func play_idle_animation(parent):
	var ANIMATION = parent.ANIMATION
	if (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_R):
		ANIMATION.play(get_proper_animation(parent,"idle_f"))
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_L):
		ANIMATION.play(get_proper_animation(parent,"idle_f_L"))
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_R):
		ANIMATION.play(get_proper_animation(parent, "idle_b"))
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_L):
		ANIMATION.play(get_proper_animation(parent, "idle_b_L"))

func play_melee_attack_animation(parent):
	if (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_R):
		await ATTACK_STATE.anticipate_and_attack(get_proper_animation(parent, "attack_f_melee_1_anticipation"), 
		get_proper_animation(parent, "attack_f_melee_1"), parent)
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_L):
		await ATTACK_STATE.anticipate_and_attack(get_proper_animation(parent, "attack_f_melee_1_L_anticipation"), 
		get_proper_animation(parent, "attack_f_melee_1_L"), parent)
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_R):
		await ATTACK_STATE.anticipate_and_attack(get_proper_animation(parent, "attack_b_melee_1_anticipation"), 
		get_proper_animation(parent, "attack_b_melee_1"), parent)
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_L):
		await ATTACK_STATE.anticipate_and_attack(get_proper_animation(parent, "attack_b_melee_1_L_anticipation"), 
		get_proper_animation(parent, "attack_b_melee_1_L"), parent)

func play_walking_animation(parent):
	if (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_R):
		parent.BODY.flip_h = false
		parent.MELEE.flip_h = false
		parent.ANIMATION.play(get_proper_animation(parent, "run_f"))
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_L):
		parent.BODY.flip_h = true
		parent.MELEE.flip_h = true
		parent.ANIMATION.play(get_proper_animation(parent, "run_f_L"))
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_R):
		parent.BODY.flip_h = false
		parent.MELEE.flip_h = false
		parent.ANIMATION.play(get_proper_animation(parent, "run_b"))
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_L):
		parent.BODY.flip_h = true
		parent.MELEE.flip_h = true
		parent.ANIMATION.play(get_proper_animation(parent, "run_b_L"))

func play_ranged_animation(parent):
	if (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_R):
		parent.BODY.flip_h = false
		ATTACK_STATE.anticipate_and_attack(get_proper_animation(parent, "attack_f_ranged_anticipation"), 
		get_proper_animation(parent, "attack_f_ranged"), parent)
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_L):
		parent.BODY.flip_h = true
		ATTACK_STATE.anticipate_and_attack(get_proper_animation(parent, "attack_f_ranged_anticipation"), 
		get_proper_animation(parent, "attack_f_ranged"), parent)
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_R):
		parent.BODY.flip_h = false
		ATTACK_STATE.anticipate_and_attack(get_proper_animation(parent, "attack_b_ranged_anticipation"), 
		get_proper_animation(parent, "attack_b_ranged"), parent)
	elif (parent.DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_L):
		parent.BODY.flip_h = true
		ATTACK_STATE.anticipate_and_attack(get_proper_animation(parent, "attack_b_ranged_anticipation"), 
		get_proper_animation(parent, "attack_b_ranged"), parent)

func play_death_animation(parent):
	var ANIMATION : AnimationPlayer = parent.ANIMATION
	ANIMATION.play(get_proper_animation(parent, "death"))
	await ANIMATION.animation_finished

func get_proper_animation(parent, animation_name : String) -> String:
	if parent is BasicEnemy:
		return "enemy_animations/" + animation_name
	if parent is Player:
		return "player_animations/" + animation_name
	return ""
