class_name Player extends CharacterBody2D
#region global variables
enum DIRECTIONS {
	UP_R,
	DOWN_R,
	UP_L,
	DOWN_L,
}
enum WEAPONS {
	AXE,
	BOW
}
var AXE_STATS = {
	"knockback": -5
}
var BOW_STATS = {
	"knockback": 3
}
enum STATE {
	IDLE,
	WALKING,
	DODGING,
	ATTACKING,
	NEUTRAL,
	ACTION
}
var MOVING_SPEED : int = 150
var VECTOR : Vector2 = Vector2.ZERO
var SPEED_BOOST : int = 1;
@onready
var ANIMATION = $AnimationPlayer
@onready
var BODY : Sprite2D = $Body
@onready
var MELEE : Sprite2D = $Melee
@onready
var RANGED : Sprite2D = $Marker2D/Ranged
@onready
var POINTER = $Marker2D
@onready
var MELEE_MARK : Sprite2D = $Marker2D/MeleeMark
var PLAYER_STATE = STATE.IDLE
var DIRECTION_FACING = DIRECTIONS.DOWN_R
var KNOCKBACK : Vector2 = Vector2.ZERO
#to be moved to inventory node
var EQUIPPED : Weapon
var EQUIPPMENT = [Axe.new(), Bow.new(), Sword.new()]
#endregion
#region main functions
func _ready():
	MELEE_MARK.visible = false
func _physics_process(_delta) -> void:
	if (PLAYER_STATE != STATE.ATTACKING):
		aim()
	show_proper_weapon()
	if (PLAYER_STATE != STATE.ATTACKING 
	&& PLAYER_STATE != STATE.DODGING 
	&& PLAYER_STATE != STATE.ACTION):
		check_player_input()
#endregion
#region aim
func aim() -> void:
	POINTER.look_at(get_global_mouse_position());
	var angle = get_angle_to(get_global_mouse_position());
	if (angle > 0 && angle < 1.5):
		DIRECTION_FACING = DIRECTIONS.DOWN_R;
		RANGED.z_index = 0
	elif (angle > 1.5):
		DIRECTION_FACING = DIRECTIONS.DOWN_L;
		RANGED.z_index = 0
	elif (angle < 0 && angle > -1.5):
		DIRECTION_FACING = DIRECTIONS.UP_R;
		RANGED.z_index = -1
	elif (angle < -1.5):
		DIRECTION_FACING = DIRECTIONS.UP_L;
		RANGED.z_index = -1
#endregion
#region player input check
func check_player_input() -> void:
	if (Input.is_anything_pressed() == false):
		idle()
	else:
		await attack()
		walk()
		change_weapon()
		await dodge()
#endregion
#region weapon change
func change_weapon() -> void:
	if (Input.is_action_just_pressed("1")):
		EQUIPPED = EQUIPPMENT[1]
		MELEE.visible = false
		RANGED.visible = true
		MELEE.texture = EQUIPPED.weaponSprite
		PLAYER_STATE = STATE.NEUTRAL
	if (Input.is_action_just_pressed("2")):
		EQUIPPED = EQUIPPMENT[0]
		MELEE.visible = true
		RANGED.visible = false
		MELEE.texture = EQUIPPED.weaponSprite
		PLAYER_STATE = STATE.NEUTRAL
	if (Input.is_action_just_pressed("3")):
		EQUIPPED = EQUIPPMENT[2]
		MELEE.visible = true
		RANGED.visible = false
		MELEE.texture = EQUIPPED.weaponSprite
		PLAYER_STATE = STATE.NEUTRAL
func show_proper_weapon() -> void:
	print(PLAYER_STATE)
	print(EQUIPPED)
	if (PLAYER_STATE != STATE.DODGING && EQUIPPED != null):
		if (EQUIPPED.isWeaponRanged == false):
			MELEE.visible = true
			RANGED.visible = false
		elif (EQUIPPED.isWeaponRanged == true):
			MELEE.visible = false
			RANGED.visible = true
#endregion
#region attack
func attack() -> void:
	if (Input.is_action_pressed("lmb") && EQUIPPED != null):
		PLAYER_STATE = STATE.ATTACKING
		if (EQUIPPED.isWeaponRanged == false):
			knockback()
			perform_melee_attack()
			await ANIMATION.animation_finished
		else:
			perform_ranged_attack()
			await ANIMATION.animation_finished
			knockback()
		PLAYER_STATE = STATE.NEUTRAL
func knockback() -> void:
	var weaponKickback: int = EQUIPPED.weaponKickback;
	var tween = create_tween()
	var target_position : Vector2 = Vector2.ZERO
	var mouse_position : Vector2 = get_global_mouse_position()
	var direction : Vector2 = mouse_position - position
	direction = direction.normalized() * -2 * weaponKickback
	target_position = position + direction
	tween.tween_property(self, "position", target_position, .1)
	tween.tween_callback(
	func end_movement():
		self.position = target_position
	)
#endregion
#region melee attack
func perform_melee_attack() -> void:
	play_melee_animation()
func play_melee_animation() -> void:
	var attackType = RandomNumberGenerator.new().randi_range(0, 1)
	if (DIRECTION_FACING == DIRECTIONS.DOWN_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		if (attackType == 1):
			ANIMATION.play("attack_f_melee_1");
		else:
			ANIMATION.play("attack_f_melee_2");
	elif (DIRECTION_FACING == DIRECTIONS.DOWN_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		if (attackType == 1):
			ANIMATION.play("attack_f_melee_1");
		else:
			ANIMATION.play("attack_f_melee_2");
	elif (DIRECTION_FACING == DIRECTIONS.UP_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		if (attackType == 1):
			ANIMATION.play("attack_b_melee_1");
		else:
			ANIMATION.play("attack_b_melee_2");
	elif (DIRECTION_FACING == DIRECTIONS.UP_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		if (attackType == 1):
			ANIMATION.play("attack_b_melee_1");
		else:
			ANIMATION.play("attack_b_melee_2");
#endregion
#region ranged attack
func perform_ranged_attack() -> void:
	play_ranged_animation()
func play_ranged_animation() -> void:
	if (DIRECTION_FACING == DIRECTIONS.DOWN_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("attack_f_ranged");
	elif (DIRECTION_FACING == DIRECTIONS.DOWN_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("attack_f_ranged");
	elif (DIRECTION_FACING == DIRECTIONS.UP_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("attack_b_ranged");
	elif (DIRECTION_FACING == DIRECTIONS.UP_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("attack_b_ranged");
#endregion
#region idle
func idle() -> void:
	PLAYER_STATE = STATE.IDLE
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
#endregion
#region walking
func walk() -> void:
	if (Input.is_action_pressed("right") 
	|| Input.is_action_pressed("left") 
	||Input.is_action_pressed("up") 
	||Input.is_action_pressed("down")):
		PLAYER_STATE = STATE.WALKING
		VECTOR.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		VECTOR.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		VECTOR = VECTOR.normalized()
		var FACING_BOOST = calculate_facing_boost()
		velocity = VECTOR * MOVING_SPEED * SPEED_BOOST * FACING_BOOST + KNOCKBACK
		play_walking_animation()
		move_and_slide()
func calculate_facing_boost() -> float:
	if (DIRECTION_FACING == DIRECTIONS.DOWN_R && VECTOR.x >= 0 && VECTOR.y >= 0):
		return 1
	if (DIRECTION_FACING == DIRECTIONS.DOWN_L && VECTOR.x <= 0 && VECTOR.y >= 0):
		return 1
	if (DIRECTION_FACING == DIRECTIONS.UP_L && VECTOR.x <= 0 && VECTOR.y <= 0):
		return 1
	if (DIRECTION_FACING == DIRECTIONS.UP_R && VECTOR.x >= 0 && VECTOR.y <= 0):
		return 1
	return 0.85
func play_walking_animation() -> void:
	if (DIRECTION_FACING == DIRECTIONS.DOWN_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("run_f")
	elif (DIRECTION_FACING == DIRECTIONS.DOWN_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("run_f")
	elif (DIRECTION_FACING == DIRECTIONS.UP_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("run_b")
	elif (DIRECTION_FACING == DIRECTIONS.UP_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("run_b")
#endregion
#region dodge
func dodge() -> void:
	if (Input.is_action_just_pressed("space")):
		PLAYER_STATE = STATE.DODGING
		MELEE.visible = false
		RANGED.visible = false
		if (DIRECTION_FACING == DIRECTIONS.DOWN_R):
			BODY.flip_h = false
			ANIMATION.play("roll_f");
		if (DIRECTION_FACING == DIRECTIONS.DOWN_L):
			BODY.flip_h = true
			ANIMATION.play("roll_f");
		if (DIRECTION_FACING == DIRECTIONS.UP_L):
			BODY.flip_h = false
			ANIMATION.play("roll_b");
		if (DIRECTION_FACING == DIRECTIONS.UP_R):
			BODY.flip_h = true
			ANIMATION.play("roll_b");
		var tween = create_tween()
		var target_position: Vector2 = Vector2.ZERO
		var mouse_position: Vector2 = get_global_mouse_position()
		var direction: Vector2 = mouse_position - position
		direction = direction.normalized() * 100
		target_position = position + direction
		tween.tween_property(self, "position", target_position, ANIMATION.get_animation("roll_f").length)
		tween.tween_callback(
		func end_movement():
			self.position = target_position
		)
		await ANIMATION.animation_finished
		PLAYER_STATE = STATE.NEUTRAL
#endregion
