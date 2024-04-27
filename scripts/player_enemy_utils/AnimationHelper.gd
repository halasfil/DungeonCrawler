class_name AnimationHelper extends Node
@onready
var BODY = $"../Body"
@onready
var MELEE = $"../Body/Melee"
@onready
var ANIMATION = $"../AnimationPlayer"
@onready
var PARENT = $".."

func play_idle_animation():
	if (PARENT.DIRECTION_FACING == PARENT.DIRECTIONS.DOWN_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("idle_f")
	elif (PARENT.DIRECTION_FACING == PARENT.DIRECTIONS.DOWN_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("idle_f")
	elif (PARENT.DIRECTION_FACING == PARENT.DIRECTIONS.UP_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("idle_b")
	elif (PARENT.DIRECTION_FACING == PARENT.DIRECTIONS.UP_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("idle_b")
