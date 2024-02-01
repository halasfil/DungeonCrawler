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
var ANIMATION : AnimationPlayer = $AnimationPlayer
@onready
var BODY : Sprite2D = $Body
@onready
var MELEE : Sprite2D = $Melee
@onready
var RANGED : Sprite2D = $Aim/Ranged
@onready
var MARKER : Marker2D = $Marker2D
@onready
var AIM = $Aim
@onready
var MELEE_MARK : Sprite2D = $Marker2D/MeleeMark
@onready 
var UI : Ui = $Ui
@onready
var INVENTORY : Inventory = $Ui/CanvasLayer/Inventory
@onready
var DODGE_COOLDOWN : Timer = $DodgeCooldown
@onready
var JOYSTICK : Joystick = UI.JOYSTICK 
@onready
var ATTACK_BUTTON : AttackButton = UI.ATTACK_BUTTON
@onready
var DODGE_BUTTON : DodgeButton  = UI.DODGE_BUTTON

var CAN_DODGE : bool = true
var PLAYER_STATE : int = STATE.NEUTRAL
var DIRECTION_FACING : int = DIRECTIONS.DOWN_R
var EQUIPPED_WEAPON : Weapon

#endregion
#region main functions
func _ready():
	MELEE_MARK.visible = false
	MELEE.visible = true
	RANGED.visible = false
	EQUIPPED_WEAPON = INVENTORY.EQUIPPED_WEAPON
	
func _physics_process(_delta):
	aim()
	show_proper_weapon()
	if (PLAYER_STATE != STATE.ATTACKING && PLAYER_STATE != STATE.DODGING && PLAYER_STATE != STATE.ACTION):
		check_player_input()
	check_equipped_weapon()
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
func check_equipped_weapon():
	EQUIPPED_WEAPON = INVENTORY.EQUIPPED_WEAPON
	if EQUIPPED_WEAPON:
		MELEE.texture = EQUIPPED_WEAPON.itemSprite
		RANGED.texture = EQUIPPED_WEAPON.itemSprite
func show_proper_weapon():
	if (PLAYER_STATE != STATE.DODGING && PLAYER_STATE != STATE.ACTION && EQUIPPED_WEAPON != null):
		if (EQUIPPED_WEAPON.isWeaponRanged == false):
			MELEE.visible = true
			RANGED.visible = false
		elif (EQUIPPED_WEAPON.isWeaponRanged == true):
			MELEE.visible = false
			RANGED.visible = true
	else:
		MELEE.visible = false
		RANGED.visible = false
#endregion
#region attack
func attack():
	if (EQUIPPED_WEAPON && ATTACK_BUTTON.pressed):
		PLAYER_STATE = STATE.ATTACKING
		if (EQUIPPED_WEAPON.isWeaponRanged == false):
			knockback()
			perform_melee_attack()
			await ANIMATION.animation_finished
		else:
			perform_ranged_attack()
			await ANIMATION.animation_finished
			knockback()
		PLAYER_STATE = STATE.NEUTRAL
func knockback():
	var weaponKickback: int = EQUIPPED_WEAPON.weaponKickback;
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
		var color_tween = create_tween()
		var target_color = Color(1,1,1,1)
		color_tween.tween_property(DODGE_BUTTON, "modulate", target_color, DODGE_COOLDOWN_TIME)
		DODGE_COOLDOWN.start(DODGE_COOLDOWN_TIME)
func _on_dodge_cooldown_timeout():
	CAN_DODGE = true
#endregion
