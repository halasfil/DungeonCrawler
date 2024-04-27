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
var RANGED_MARK : Sprite2D = $Body/Aim/Ranged/RangedMark
@onready
var AIM = $Body/Aim
@onready 
var UI : Ui = $Ui
@onready
var INVENTORY : Inventory = $Ui/CanvasLayer/Inventory
@onready
var DODGE_COOLDOWN : Timer = $DodgeCooldown
@onready
var MELEE_COLISION : CollisionPolygon2D = $Body/Aim/MeleeArea/CollisionPolygon2D
@onready
var NO_ARMOR_SKIN : CompressedTexture2D = preload("res://assets/player/skins/no_armor.png")
@onready
var JOYSTICK : Joystick = UI.JOYSTICK 
@onready
var ATTACK_BUTTON : AttackButton = UI.ATTACK_BUTTON
@onready
var DODGE_BUTTON : DodgeButton  = UI.DODGE_BUTTON
@onready
var POINTER : Sprite2D = $Body/Aim/Pointer
@onready
var ANIMATION_HELPER : AnimationHelper = $AnimationHelper
var PROJECTILE_SCENE : PackedScene = preload("res://scenes/player/projectile.tscn")
var CAN_DODGE : bool = true
var PLAYER_STATE : int = STATE.IDLE
var DIRECTION_FACING : int = DIRECTIONS.DOWN_R
var EQUIPPED_WEAPON : Weapon
var EQUIPPED_ARMOR : Armor
var KNOCKBACK : bool = false
var DODGING : bool = false
#endregion
#region main functions
func _ready():
	MELEE_COLISION.disabled = true
func _physics_process(_delta):
	aim()
	show_proper_weapon()
	if (PLAYER_STATE == STATE.WALKING || PLAYER_STATE == STATE.IDLE):
		check_player_input()
	check_equipped_weapon()
	check_equipped_armor()
	if KNOCKBACK:
		perform_knockback()
	if DODGING:
		perform_dodging()
	$state.text = String.num(PLAYER_STATE)
#endregion
#region general util functions
func move_like_tween(direction, speed, duration, knockback_reset, dodge_reset):
	velocity = direction * speed
	move_and_slide()
	await get_tree().create_timer(duration).timeout
	if (knockback_reset):
		KNOCKBACK = false
	if (dodge_reset):
		DODGING = false
#endregion
#region aim
func aim():
	var angle : float = JOYSTICK.angle
	AIM.rotation = angle
	if (PLAYER_STATE != STATE.ATTACKING):
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
			perform_melee_attack()
		else:
			perform_ranged_attack()
		await ANIMATION.animation_finished
		PLAYER_STATE = STATE.IDLE
func perform_knockback():
	var weaponKickback: int = EQUIPPED_WEAPON.weaponKickback;
	var aim_position : Vector2 = POINTER.global_position
	var direction : Vector2 = (aim_position - position).normalized()
	direction = direction * -1 * weaponKickback
	await move_like_tween(direction, 20, .1, true, false)
#endregion
#region melee attack
func perform_melee_attack():
	await play_melee_animation()
func anticipate_and_attack(anticipationAnimationName : String, animationName : String):
	ANIMATION.play(anticipationAnimationName)
	await get_tree().create_timer(EQUIPPED_WEAPON.weaponAnticipationTime).timeout
	KNOCKBACK = true
	ANIMATION.play(animationName);
func play_melee_animation():
	var attackType = RandomNumberGenerator.new().randi_range(0, 1)
	if (DIRECTION_FACING == DIRECTIONS.DOWN_R):
		if (attackType == 1):
			anticipate_and_attack("attack_f_melee_1_anticipation", "attack_f_melee_1")
		else:
			anticipate_and_attack("attack_f_melee_2_anticipation", "attack_f_melee_2")
	elif (DIRECTION_FACING == DIRECTIONS.DOWN_L):
		if (attackType == 1):
			anticipate_and_attack("attack_f_melee_1_L_anticipation", "attack_f_melee_1_L")
		else:
			anticipate_and_attack("attack_f_melee_2_L_anticipation", "attack_f_melee_2_L")
	elif (DIRECTION_FACING == DIRECTIONS.UP_R):
		if (attackType == 1):
			anticipate_and_attack("attack_b_melee_1_anticipation", "attack_b_melee_1")
		else:
			anticipate_and_attack("attack_b_melee_2_anticipation", "attack_b_melee_2")
	elif (DIRECTION_FACING == DIRECTIONS.UP_L):
		if (attackType == 1):
			anticipate_and_attack("attack_b_melee_1_L_anticipation", "attack_b_melee_1_L")
		else:
			anticipate_and_attack("attack_b_melee_2_L_anticipation", "attack_b_melee_2_L")
#endregion
#region ranged attack
func perform_ranged_attack():
	await play_ranged_animation()
	shoot_projectile()
func shoot_projectile():
	var projectile : Projectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = POINTER.global_position
	projectile.rotation = AIM.rotation
	projectile.MIN_DAMAGE = EQUIPPED_WEAPON.weaponMinDamage
	projectile.MAX_DAMAGE = EQUIPPED_WEAPON.weaponMaxDamage
	projectile.PROJECTILE_SPRITE = EQUIPPED_WEAPON.projectileSprite
	var aimPositon : Vector2 = POINTER.global_position
	var shootAngle : Vector2 = (aimPositon - position).normalized()
	projectile.velocity =  shootAngle * 3
	projectile.PUSHBACK_STRENGTH = EQUIPPED_WEAPON.weaponPushback
func play_ranged_animation():
	if (DIRECTION_FACING == DIRECTIONS.DOWN_R):
		BODY.flip_h = false
		anticipate_and_attack("attack_f_ranged_anticipation", "attack_f_ranged")
	elif (DIRECTION_FACING == DIRECTIONS.DOWN_L):
		BODY.flip_h = true
		anticipate_and_attack("attack_f_ranged_anticipation", "attack_f_ranged")
	elif (DIRECTION_FACING == DIRECTIONS.UP_R):
		BODY.flip_h = false
		anticipate_and_attack("attack_b_ranged_anticipation", "attack_b_ranged")
	elif (DIRECTION_FACING == DIRECTIONS.UP_L):
		BODY.flip_h = true
		anticipate_and_attack("attack_b_ranged_anticipation", "attack_b_ranged")
#endregion
#region walking
func walk_or_idle():
	var walkingDirection : Vector2 = JOYSTICK.posVector
	if (walkingDirection):
		var walkingSpeedReducer : float = EQUIPPED_ARMOR.walkingSpeedReducer if EQUIPPED_ARMOR != null else 1.0
		velocity = walkingDirection * MOVING_SPEED * walkingSpeedReducer
		play_walking_animation()
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		ANIMATION_HELPER.play_idle_animation()
func play_walking_animation():
	PLAYER_STATE = STATE.WALKING
	if (DIRECTION_FACING == DIRECTIONS.DOWN_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("run_f")
	elif (DIRECTION_FACING == DIRECTIONS.DOWN_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("run_f_L")
	elif (DIRECTION_FACING == DIRECTIONS.UP_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("run_b")
	elif (DIRECTION_FACING == DIRECTIONS.UP_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("run_b_L")
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
		ANIMATION.play("idle_f_L")
	elif (DIRECTION_FACING == DIRECTIONS.UP_R):
		BODY.flip_h = false
		MELEE.flip_h = false
		ANIMATION.play("idle_b")
	elif (DIRECTION_FACING == DIRECTIONS.UP_L):
		BODY.flip_h = true
		MELEE.flip_h = true
		ANIMATION.play("idle_b_L")
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
		DODGING = true
		await ANIMATION.animation_finished
		PLAYER_STATE = STATE.IDLE
		var color_tween : Tween = create_tween()
		var target_color : Color = Color(1,1,1,1)
		color_tween.tween_property(DODGE_BUTTON, "modulate", target_color, DODGE_COOLDOWN_TIME)
		DODGE_COOLDOWN.start(DODGE_COOLDOWN_TIME)
func perform_dodging():
	var aim_position : Vector2 = POINTER.global_position
	var direction: Vector2 = (aim_position - position).normalized()
	await move_like_tween(direction, 300, ANIMATION.get_animation("roll_f").length, false, true)
func _on_dodge_cooldown_timeout():
	CAN_DODGE = true
#endregion


