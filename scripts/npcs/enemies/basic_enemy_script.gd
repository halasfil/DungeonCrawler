class_name BasicEnemy extends CharacterBody2D

@onready
var PLAYER_NODE : Player = get_parent().get_node("Player")
@onready
var ANIMATION = $AnimationPlayer;
@onready
var BODY : Sprite2D = $Body;
@onready
var MELEE : Sprite2D = $Body/Melee;
@onready 
var STATS : BasicEnemyParentResource;
@onready
var DAMAGE_TAKER : DamageTakerComponent = $DamageTaker
@onready
var HEALTH_BAR : ProgressBar = $ProgressBar
enum STATES {
	IDLE,
	CHASE,
	ATTACK,
	RUN_AWAY,
	FEAR,
	DYING
}
enum DIRECTIONS {
	UP_R,
	DOWN_R,
	UP_L,
	DOWN_L,
}
@onready
var DIRECTION_FACING : int = DIRECTIONS.DOWN_R
@onready
var STATE : STATES = STATES.IDLE
@onready
var HEALTH : int = 30

func _ready():
	HEALTH_BAR.max_value = HEALTH
	
func _process(_delta):
	if (STATS):
		#todo - handle stats
		idle()
	if (STATE == STATES.IDLE):
		idle()
	if (STATE == STATES.DYING):
		die()
	update_health_bar()
	
func die():
	if (HEALTH <= 0):
		ANIMATION.play("death")
		await ANIMATION.animation_finished
		queue_free()

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
		
func take_damage(min_damage : int, max_damage : int, pushback_strength : int):
	var damage = DAMAGE_TAKER.take_damage(min_damage, max_damage)
	HEALTH -= damage
	if (HEALTH <= 0):
		STATE = STATES.DYING
	hit_effect()
	pushback(pushback_strength)
	
func pushback(pushback_strength : int):
	var pushbackDirection : Vector2 = (PLAYER_NODE.global_position - global_position).normalized()
	velocity = pushbackDirection * 100 * pushback_strength
	move_and_slide()

func hit_effect():
	BODY.modulate = Color.WEB_MAROON
	await get_tree().create_timer(0.1).timeout
	BODY.modulate = Color.WHITE

func update_health_bar():
	HEALTH_BAR.value = HEALTH
