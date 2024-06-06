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
var RANGED : Sprite2D = $Body/Aim/Ranged;
@onready
var DAMAGE_TAKER : DamageTakerComponent = $DamageTaker
@onready
var HEALTH_BAR : ProgressBar = $ProgressBar
@onready
var NAVAGENT : NavigationAgent2D = $Body/Aim/MeleeDetector/NavigationAgent2D
@onready
var AIM : Marker2D = $Body/Aim
@onready
var STATES_AND_HELPERS : StatesAndHelpers = $StatesAndHelpers
@onready
var STATE_LABEL : Label = $stateLabel
@onready
var POINTER : Sprite2D = $Body/Aim/Pointer
@onready
var MELEE_DETECTOR : Area2D = $Body/Aim/MeleeDetector
@onready
var RANGED_DETECTOR : RayCast2D = $Body/Aim/RangedDetector

@onready
var ENEMY_RESOURCE : BasicEnemyParentResource = Draugr.new();

enum STATES {
	IDLE,
	WALKING,
	ATTACKING,
	RUN_AWAY,
	FEAR,
	DYING
}
var DIRECTION_FACING : int = STATES_AND_HELPERS.DIRECTIONS.DOWN_R
var STATE : STATES = STATES.IDLE

var KNOCKBACK : bool = false
var IS_ATTACKING : bool = false
var SEE_PLAYER : bool = false

@onready
var EQUIPPED_WEAPON : Weapon = ENEMY_RESOURCE.weapon
@onready
var HEALTH : int = ENEMY_RESOURCE.health
@onready
var IS_RANGED : bool = EQUIPPED_WEAPON.isWeaponRanged
@onready
var WALKING_SPEED : int = ENEMY_RESOURCE.walkingSpeed

func _ready():
	HEALTH_BAR.max_value = HEALTH
	EQUIPPED_WEAPON.weaponAnticipationTime = EQUIPPED_WEAPON.weaponAnticipationTime * 3
	if (IS_RANGED):
		MELEE.visible = false
		RANGED.visible = true
	else:
		MELEE.visible = true
		RANGED.visible = false
	for animName in ANIMATION.get_animation_list():
		var a : Animation = ANIMATION.get_animation(animName)
		print(animName)
		print(a.length)
	
	
func _physics_process(_delta):
	if (STATE != STATES.ATTACKING && velocity == Vector2.ZERO  && !IS_ATTACKING):
		STATE = STATES.IDLE
	if (STATE == STATES.IDLE && !IS_ATTACKING):
		idle()
	if (STATE == STATES.DYING && !IS_ATTACKING):
		await die()
	if (STATE == STATES.ATTACKING && !IS_ATTACKING):
		await attack()
	if (STATE == STATES.WALKING && !IS_ATTACKING):
		walk()
	if (STATE != STATES.ATTACKING):
		IS_ATTACKING = false
		$Body/Aim/MeleeArea/CollisionPolygon2D.disabled = true
		aim()
	if KNOCKBACK:
		perform_knockback()
	update_health_bar()
	if (STATE == STATES.WALKING || STATE==STATES.IDLE):
		chase()
	check_ranged_area()
	STATE_LABEL.text = String.num(STATE)
	
func walk():
	STATES_AND_HELPERS.ANIMATION_HELPER.play_walking_animation(self)

func check_ranged_area():
	if (RANGED_DETECTOR.get_collider() && RANGED_DETECTOR.get_collider() == PLAYER_NODE):
		if IS_RANGED:
			STATE = STATES.ATTACKING
	
func aim():
	var angle : float = AIM.global_rotation
	if (angle > 0 && angle < 1.5):
		DIRECTION_FACING = STATES_AND_HELPERS.DIRECTIONS.DOWN_R;
		AIM.show_behind_parent = false
		MELEE.show_behind_parent = false
	elif (angle > 1.5):
		DIRECTION_FACING = STATES_AND_HELPERS.DIRECTIONS.DOWN_L;
		MELEE.show_behind_parent = false
		AIM.show_behind_parent = false
	elif (angle < 0 && angle > -1.5):
		DIRECTION_FACING = STATES_AND_HELPERS.DIRECTIONS.UP_R;
		MELEE.show_behind_parent = true
		AIM.show_behind_parent = true
	elif (angle < -1.5):
		DIRECTION_FACING = STATES_AND_HELPERS.DIRECTIONS.UP_L;
		MELEE.show_behind_parent = true
		AIM.show_behind_parent = true

func chase():
	if (SEE_PLAYER):
		var axis : Vector2 = to_local(NAVAGENT.get_next_path_position()).normalized();
		var intendedVelocity  : Vector2 = axis * WALKING_SPEED
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
	IS_ATTACKING = true
	velocity = Vector2.ZERO
	if (IS_RANGED):
		await STATES_AND_HELPERS.ANIMATION_HELPER.play_ranged_animation(self)
	else:
		await STATES_AND_HELPERS.ANIMATION_HELPER.play_melee_attack_animation(self)
	await ANIMATION.animation_finished
	if (HEALTH > 0):
		await get_tree().create_timer(1).timeout
		IS_ATTACKING = false
		if (!MELEE_DETECTOR.overlaps_body(PLAYER_NODE)):
			STATE = STATES.IDLE

func take_damage(min_damage : int, max_damage : int, pushback_strength : int, attacker):
	if (attacker != self):
		var damage : int = DAMAGE_TAKER.calculate_damage(min_damage, max_damage)
		HEALTH -= damage
		if (HEALTH <= 0):
			STATE = STATES.DYING
		hit_effect()
		perform_pushback(attacker, pushback_strength)

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
		velocity = Vector2.ZERO
		STATE = STATES.ATTACKING

func _on_melee_detector_body_exited(body):
	if (body is Player):
		velocity = Vector2.ZERO

func makePath():
	if (SEE_PLAYER && PLAYER_NODE):
		NAVAGENT.target_position = PLAYER_NODE.global_position

func _on_timer_timeout():
	if (SEE_PLAYER && STATE != STATES.ATTACKING):
		makePath()

func _on_navigation_agent_2d_velocity_computed(safe_velocity : Vector2):
	if (SEE_PLAYER && HEALTH > 0 && STATE != STATES.ATTACKING):
		velocity = safe_velocity * .66
		STATE = STATES.WALKING
		move_and_slide()
	
func perform_knockback():
	var weaponKickback: int = EQUIPPED_WEAPON.weaponKickback;
	var aim_position : Vector2 = POINTER.global_position
	var direction : Vector2 = (aim_position - position).normalized()
	direction = direction * -1 * weaponKickback
	await move_like_tween(direction, 20, .1, true)

func perform_pushback(attacker, pushback_strength : int):
	var direction : Vector2 = (attacker.global_position - self.global_position).normalized()
	direction = direction * pushback_strength
	await move_like_tween(direction, 300, .4, false)
	
func move_like_tween(direction, speed, duration, knockback_reset):
	velocity = direction * speed
	move_and_slide()
	await get_tree().create_timer(duration).timeout
	if (knockback_reset):
		KNOCKBACK = false
