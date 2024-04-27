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
var ANIMATION_HELPER : AnimationHelper = $AnimationHelper
@onready
var NAVAGENT : NavigationAgent2D = $NavigationAgent2D;
@onready
var AIM : Marker2D = $Body/Aim

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
@onready
var SEE_PLAYER : bool = false

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
	chase_and_attack()
	
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
	STATE = STATES.IDLE
	ANIMATION_HELPER.play_idle_animation()
		
func take_damage(min_damage : int, max_damage : int, pushback_strength : int):
	var damage : int = DAMAGE_TAKER.take_damage(min_damage, max_damage)
	print(str(damage))
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

func makePath() -> void:
	if (SEE_PLAYER && PLAYER_NODE):
		NAVAGENT.target_position = PLAYER_NODE.global_position

func _on_timer_timeout():
	makePath()

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if (SEE_PLAYER):
		velocity = safe_velocity
		move_and_slide()
