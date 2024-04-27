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
		ANIMATION.play("idle_f")
	elif (PARENT.DIRECTION_FACING == PARENT.DIRECTIONS.DOWN_L):
		ANIMATION.play("idle_f_L")
	elif (PARENT.DIRECTION_FACING == PARENT.DIRECTIONS.UP_R):
		ANIMATION.play("idle_b")
	elif (PARENT.DIRECTION_FACING == PARENT.DIRECTIONS.UP_L):
		ANIMATION.play("idle_b_L")
