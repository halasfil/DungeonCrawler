class_name Player extends CharacterBody2D
#region global variables
enum DIRECTIONS {
	UP_R,
	DOWN_R,
	UP_L,
	DOWN_L,
}
enum STATE {
	IDLE,
	WALKING,
	DODGING,
	ATTACKING,
	NEUTRAL,
	ACTION
}
var MOVING_SPEED : int = 100
var VECTOR : Vector2 = Vector2.ZERO
var SPEED_BOOST : int = 1;
var DODGE_COOLDOWN_TIME : int = 1;
@onready
var ANIMATION = $AnimationPlayer
@onready
var BODY : Sprite2D = $Body
@onready
var MELEE : Sprite2D = $Melee
@onready
var RANGED : Sprite2D = $Marker2D/Ranged
@onready
var MARKER = $Marker2D
@onready
var AIM = $Aim
@onready
var MELEE_MARK : Sprite2D = $Marker2D/MeleeMark
@onready 
var UI = $Ui
@onready
var DODGE_COOLDOWN = $DodgeCooldown
@onready
var JOYSTICK = UI.JOYSTICK
@onready
var ATTACK_BUTTON = UI.ATTACK_BUTTON
@onready
var DODGE_BUTTON = UI.DODGE_BUTTON

var CAN_DODGE = true
var PLAYER_STATE = STATE.NEUTRAL
var DIRECTION_FACING = DIRECTIONS.DOWN_R

#to be moved to inventory node
var EQUIPPED : Weapon
var EQUIPPMENT = [Axe.new(), Bow.new(), Sword.new()]
#endregion
#region main functions
func _ready():
	MELEE_MARK.visible = false
	#to be deleted after making inventory
	EQUIPPED = EQUIPPMENT[0]
	MELEE.visible = true
	RANGED.visible = false
	MELEE.texture = EQUIPPED.weaponSprite
	
func _physics_process(_delta):
	aim()
	show_proper_weapon()
	if (PLAYER_STATE != STATE.ATTACKING 
	&& PLAYER_STATE != STATE.DODGING 
	&& PLAYER_STATE != STATE.ACTION):
		check_player_input()
#endregion
#region aim
func aim():
	var angle = JOYSTICK.angle
	AIM.rotation = angle
	if (PLAYER_STATE != STATE.ATTACKING):
		MARKER.rotation = angle;
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
func check_player_input():
	walk_or_idle()
	await attack()
	await dodge()
#endregion
#region weapon change
func change_weapon():
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
func show_proper_weapon():
	if (PLAYER_STATE != STATE.DODGING && PLAYER_STATE != STATE.ACTION && EQUIPPED != null):
		if (EQUIPPED.isWeaponRanged == false):
			MELEE.visible = true
			RANGED.visible = false
		elif (EQUIPPED.isWeaponRanged == true):
			MELEE.visible = false
			RANGED.visible = true
#endregion
#region attack
func attack():
	if(ATTACK_BUTTON.pressed):
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
func knockback():
	var weaponKickback: int = EQUIPPED.weaponKickback;
	var tween = create_tween()
	var target_position : Vector2 = Vector2.ZERO
	var aim_position : Vector2 = $"Marker2D/Aim-helper".global_position
	var direction : Vector2 = aim_position - position
	direction = direction.normalized() * -2 * weaponKickback
	target_position = position + direction
	tween.tween_property(self, "position", target_position, .1)
	tween.tween_callback(
	func end_movement():
		self.position = target_position
	)
#endregion
#region melee attack
func perform_melee_attack():
	play_melee_animation()
func play_melee_animation():
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
func perform_ranged_attack():
	play_ranged_animation()
func play_ranged_animation():
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
#region walking
func walk_or_idle():
	var walkingDirection = JOYSTICK.posVector
	if (walkingDirection):
		velocity = walkingDirection * MOVING_SPEED * SPEED_BOOST
		play_walking_animation()
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		idle()
func play_walking_animation():
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
#region idle
func idle():
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
#region dodge
func dodge():
	if (DODGE_BUTTON.pressed && CAN_DODGE):
		CAN_DODGE = false
		PLAYER_STATE = STATE.DODGING
		MELEE.visible = false
		RANGED.visible = false
		print(DODGE_BUTTON.modulate)
		DODGE_BUTTON.modulate = Color(1,1,1,0.5)
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
		var aim_position : Vector2 = $"Marker2D/Aim-helper".global_position
		var direction: Vector2 = aim_position - position
		direction = direction.normalized() * 100
		target_position = position + direction
		tween.tween_property(self, "position", target_position, ANIMATION.get_animation("roll_f").length)
		tween.tween_callback(
		func end_movement():
			self.position = target_position
		)
		await ANIMATION.animation_finished
		PLAYER_STATE = STATE.NEUTRAL
		DODGE_COOLDOWN.start(DODGE_COOLDOWN_TIME)
func _on_dodge_cooldown_timeout():
	CAN_DODGE = true
	DODGE_BUTTON.modulate = Color(1,1,1,1)
#endregion
