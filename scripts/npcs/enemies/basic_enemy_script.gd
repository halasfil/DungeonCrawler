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
@onready
var NAVAGENT : NavigationAgent2D = $NavigationAgent2D;
@onready
var AIM : Marker2D = $Body/Aim
@onready
var STATES_AND_HELPERS : StatesAndHelpers = $StatesAndHelpers
@onready
var STATE_LABEL = $stateLabel

enum STATES {
	IDLE,
	WALKING,
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
@onready
var SEE_PLAYER : bool = false
@onready
var CAN_ATTACK : bool = false

func _ready():
	HEALTH_BAR.max_value = HEALTH
	
func _process(_delta):
	if (!CAN_ATTACK && velocity == Vector2.ZERO):
		STATE = STATES.IDLE
	if (STATE == STATES.IDLE):
		idle()
	if (STATE == STATES.DYING):
		await die()
	if (STATE == STATES.ATTACK):
		await attack()
	if (STATE == STATES.WALKING):
		walk()
	update_health_bar()
	chase_and_attack()
	aim()
	STATE_LABEL.text = String.num(STATE)
	
func walk():
	STATES_AND_HELPERS.ANIMATION_HELPER.play_walking_animation(self)
	
func aim():
	var angle : float = AIM.global_rotation
	if (angle > 0 && angle < 1.5):
		DIRECTION_FACING = DIRECTIONS.DOWN_R;
		AIM.show_behind_parent = false
		MELEE.show_behind_parent = false
	elif (angle > 1.5):
		DIRECTION_FACING = DIRECTIONS.DOWN_L;
		MELEE.show_behind_parent = false
		AIM.show_behind_parent = false
	elif (angle < 0 && angle > -1.5):
		DIRECTION_FACING = DIRECTIONS.UP_R;
		MELEE.show_behind_parent = true
		AIM.show_behind_parent = true
	elif (angle < -1.5):
		DIRECTION_FACING = DIRECTIONS.UP_L;
		MELEE.show_behind_parent = true
		AIM.show_behind_parent = true

func chase_and_attack():
	if (SEE_PLAYER):
		var axis : Vector2 = to_local(NAVAGENT.get_next_path_position()).normalized();
		var intendedVelocity  : Vector2 = axis * 500
		NAVAGENT.set_velocity(intendedVelocity)
		AIM.look_at(PLAYER_NODE.global_position)
	
func die():
	if (HEALTH <= 0):
		ANIMATION.play("death")
		await ANIMATION.animation_finished
		queue_free()

func idle():
	STATES_AND_HELPERS.ANIMATION_HELPER.play_idle_animation(self)

func attack():
	#STATES_AND_HELPERS.ANIMATION_HELPER.play_attack_animation(self)
	ANIMATION.stop()

func take_damage(min_damage : int, max_damage : int, pushback_strength : int):
	var damage : int = DAMAGE_TAKER.take_damage(min_damage, max_damage)
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

func _on_navigation_area_body_entered(body):
	if (body is Player):
		SEE_PLAYER = true

func _on_navigation_area_body_exited(body):
	if (body is Player):
		SEE_PLAYER = false

func _on_melee_detector_body_entered(body):
	if (body is Player):
		STATE = STATES.ATTACK
		CAN_ATTACK = true

func _on_melee_detector_body_exited(body):
	if (body is Player):
		CAN_ATTACK = false

func makePath() -> void:
	if (SEE_PLAYER && PLAYER_NODE):
		NAVAGENT.target_position = PLAYER_NODE.global_position

func _on_timer_timeout():
	makePath()

func _on_navigation_agent_2d_velocity_computed(safe_velocity : Vector2):
	if (SEE_PLAYER && !CAN_ATTACK && HEALTH > 0):
		velocity = safe_velocity
		STATE = STATES.WALKING
		move_and_slide()

