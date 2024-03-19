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
var DODGE_COOLDOWN_TIME : int = 1;
@onready
var ANIMATION : AnimationPlayer = $AnimationPlayer
@onready
var BODY : Sprite2D = $Body
@onready
var MELEE : Sprite2D = $Body/Melee
@onready
var RANGED : Sprite2D = $Body/Aim/Ranged
@onready
var MARKER : Marker2D = $Marker2D
@onready
var AIM = $Body/Aim
@onready
var MELEE_MARK : Sprite2D = $Marker2D/MeleeMark
@onready 
var UI : Ui = $Ui
@onready
var INVENTORY : Inventory = $Ui/CanvasLayer/Inventory
@onready
var DODGE_COOLDOWN : Timer = $DodgeCooldown
@onready
var AIM_HELPER : Marker2D = $"Marker2D/Aim-helper"
@onready
var NO_ARMOR_SKIN : CompressedTexture2D = preload("res://assets/player/skins/no_armor.png")
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
var EQUIPPED_ARMOR : Armor
var KNOCKBACK_STATE : bool = false
var DODGING_STATE : bool = false
#endregion
#region main functions
func _physics_process(_delta):
	aim()
	show_proper_weapon()
	if (PLAYER_STATE != STATE.ATTACKING && PLAYER_STATE != STATE.DODGING && PLAYER_STATE != STATE.ACTION):
		check_player_input()
	check_equipped_weapon()
	check_equipped_armor()
	calculate_knockback()
	calculate_dodging()
#endregion
#region general util functions
func move_like_tween(direction, speed, duration, knockback_reset, dodge_reset):
	velocity = direction * speed
	move_and_slide()
	await get_tree().create_timer(duration).timeout
	if (knockback_reset):
		KNOCKBACK_STATE = false
	if (dodge_reset):
		DODGING_STATE = false
#endregion
#region aim
func aim():
	var angle = JOYSTICK.angle
	AIM.rotation = angle
	if (PLAYER_STATE != STATE.ATTACKING):
		MARKER.rotation = angle;
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
#endregion
#region player input check
func check_player_input():
	walk_or_idle()
	await attack()
	await dodge()
#endregion
#region armor change
func check_equipped_armor():
	EQUIPPED_ARMOR = INVENTORY.EQUIPPED_ARMOR
	if !EQUIPPED_ARMOR:
		BODY.texture = NO_ARMOR_SKIN
	else:
		BODY.texture = EQUIPPED_ARMOR.characterSkin
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
			KNOCKBACK_STATE = true
			perform_melee_attack()
			await ANIMATION.animation_finished
		else:
			KNOCKBACK_STATE = true
			perform_ranged_attack()
			await ANIMATION.animation_finished

		PLAYER_STATE = STATE.NEUTRAL
func calculate_knockback():
	if KNOCKBACK_STATE == true:
		var weaponKickback: int = EQUIPPED_WEAPON.weaponKickback;
		var aim_position : Vector2 = AIM_HELPER.global_position
		var direction : Vector2 = (aim_position - position).normalized()
		direction = direction * -1 * weaponKickback
		await move_like_tween(direction, 20, .1, true, false)
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
			ANIMATION.play("attack_f_melee_1_L");
		else:
			ANIMATION.play("attack_f_melee_2_L");
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
			ANIMATION.play("attack_b_melee_1_L");
		else:
			ANIMATION.play("attack_b_melee_2_L");
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
		var walkingSpeedReducer = EQUIPPED_ARMOR.walkingSpeedReducer if EQUIPPED_ARMOR != null else 1.0
		velocity = walkingDirection * MOVING_SPEED * walkingSpeedReducer
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
		DODGING_STATE = true
		await ANIMATION.animation_finished
		PLAYER_STATE = STATE.NEUTRAL
		var color_tween = create_tween()
		var target_color = Color(1,1,1,1)
		color_tween.tween_property(DODGE_BUTTON, "modulate", target_color, DODGE_COOLDOWN_TIME)
		DODGE_COOLDOWN.start(DODGE_COOLDOWN_TIME)
func calculate_dodging():
	if DODGING_STATE:
		var aim_position : Vector2 = AIM_HELPER.global_position
		var direction: Vector2 = (aim_position - position).normalized()
		await move_like_tween(direction, 300, ANIMATION.get_animation("roll_f").length, false, true)
func _on_dodge_cooldown_timeout():
	CAN_DODGE = true
#endregion
