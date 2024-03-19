class_name BasicEnemy extends Node

@onready
var ANIMATION = $AnimationPlayer;
@onready
var BODY : Sprite2D = $Body;
@onready
var MELEE : Sprite2D = $Body/Melee;
@onready 
var enemyStats : BasicEnemyParentResource;
enum STATES {
	IDLE,
	CHASE,
	ATTACK,
	RUN_AWAY,
	FEAR
}
enum DIRECTIONS {
	UP_R,
	DOWN_R,
	UP_L,
	DOWN_L,
}
var DIRECTION_FACING : int = DIRECTIONS.DOWN_R
var STATE : STATES = STATES.IDLE

func _process(_delta):
	if (enemyStats):
		#todo
		idle()
	idle()
	
func idle():
	STATE = STATES.IDLE
	play_idle_animation()
	
func play_idle_animation():
	if (DIRECTION_FACING == DIRECTIONS.DOWN_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("idle_f")
	elif (DIRECTION_FACING == DIRECTIONS.DOWN_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("idle_f")
	elif (DIRECTION_FACING == DIRECTIONS.UP_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("idle_b")
	elif (DIRECTION_FACING == DIRECTIONS.UP_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("idle_b")
