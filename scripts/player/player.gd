class_name Player extends CharacterBody2D
#region global variables
enum STATES {
	IDLE,
	WALKING,
	DODGING,
	ATTACKING,
	ACTION,
	DYING
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
var HEALTH_BAR : ProgressBar = UI.HEALTH_BAR
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
var STATES_AND_HELPERS : StatesAndHelpers = $StatesAndHelpers
@onready
var DAMAGE_TAKER : DamageTakerComponent = $DamageTakerComponent
var PROJECTILE_SCENE : PackedScene = preload("res://scenes/player/projectile.tscn")
var CAN_DODGE : bool = true
var STATE : int = STATES.IDLE
var DIRECTION_FACING : int = STATES_AND_HELPERS.DIRECTIONS.DOWN_R
var EQUIPPED_WEAPON : Weapon
var EQUIPPED_ARMOR : Armor
var KNOCKBACK : bool = false
var DODGING : bool = false
var HEALTH : int = 100
#endregion
#region main functions
func _ready():
	MELEE_COLISION.disabled = true
	
func _physics_process(_delta):
	aim()
	show_proper_weapon()
	if (STATE == STATES.WALKING || STATE == STATES.IDLE):
		check_player_input()
	check_equipped_weapon()
	check_equipped_armor()
	if KNOCKBACK:
		perform_knockback()
	if DODGING:
		perform_dodging()
	update_health_bar()
	$state.text = String.num(STATE)
#endregion
#region util
func update_health_bar():
	HEALTH_BAR.value = HEALTH
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
	if (STATE != STATES.ATTACKING):
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
		if EQUIPPED_WEAPON.isWeaponRanged:
			RANGED_MARK.texture = EQUIPPED_WEAPON.animationForRangedSprite
func show_proper_weapon():
	if (STATE != STATES.DODGING && STATE != STATES.ACTION && EQUIPPED_WEAPON != null):
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
		STATE = STATES.ATTACKING
		if (EQUIPPED_WEAPON.isWeaponRanged == false):
			await STATES_AND_HELPERS.ANIMATION_HELPER.play_melee_attack_animation(self)
		else:
			await perform_ranged_attack()
		await ANIMATION.animation_finished
		STATE = STATES.IDLE
func perform_knockback():
	var aim_position : Vector2 = POINTER.global_position
	var direction : Vector2 = (aim_position - position).normalized()
	direction = direction * -1 * EQUIPPED_WEAPON.weaponKickback
	await move_like_tween(direction, 20, .1, true, false)
#endregion
#region melee attack
#endregion
#region ranged attack
func perform_ranged_attack():
	await STATES_AND_HELPERS.ANIMATION_HELPER.play_ranged_animation(self)
	shoot_projectile()
func shoot_projectile():
	var projectile : Projectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = POINTER.global_position
	projectile.rotation = AIM.rotation
	projectile.MIN_DAMAGE = EQUIPPED_WEAPON.weaponMinDamage
	projectile.MAX_DAMAGE = EQUIPPED_WEAPON.weaponMaxDamage
	projectile.PROJECTILE_SPRITE = EQUIPPED_WEAPON.projectileSprite
	projectile.PUSHBACK_STRENGTH = EQUIPPED_WEAPON.weaponPushback
	projectile.SHOOTER = self
	var aimPositon : Vector2 = POINTER.global_position
	var shootAngle : Vector2 = (aimPositon - position).normalized()
	projectile.velocity =  shootAngle * 3
#endregion
#region walking
func walk_or_idle():
	var walkingDirection : Vector2 = JOYSTICK.posVector
	if (walkingDirection):
		STATE = STATES.WALKING
		STATES_AND_HELPERS.ANIMATION_HELPER.play_walking_animation(self)
		var walkingSpeedReducer : float = EQUIPPED_ARMOR.walkingSpeedReducer if EQUIPPED_ARMOR != null else 1.0
		velocity = walkingDirection * MOVING_SPEED * walkingSpeedReducer
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		STATE = STATES.IDLE
		STATES_AND_HELPERS.ANIMATION_HELPER.play_idle_animation(self)
#endregion
#region dodge
func dodge():
	if (DODGE_BUTTON.pressed && CAN_DODGE):
		CAN_DODGE = false
		STATE = STATES.DODGING
		MELEE.visible = false
		RANGED.visible = false
		DODGE_BUTTON.modulate = Color(1,1,1,0.5)
		if (DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_R):
			BODY.flip_h = false
			ANIMATION.play("roll_f");
		if (DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.DOWN_L):
			BODY.flip_h = true
			ANIMATION.play("roll_f");
		if (DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_L):
			BODY.flip_h = false
			ANIMATION.play("roll_b");
		if (DIRECTION_FACING == STATES_AND_HELPERS.DIRECTIONS.UP_R):
			BODY.flip_h = true
			ANIMATION.play("roll_b");
		DODGING = true
		await ANIMATION.animation_finished
		STATE = STATES.IDLE
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
func take_damage(min_damage : int, max_damage : int, pushback_strength : int, attacker):
	if (attacker != self):
		var damage : int = DAMAGE_TAKER.calculate_damage(min_damage, max_damage)
		HEALTH -= damage
		if (HEALTH <= 0):
			STATE = STATES.DYING
		hit_effect()
		pushback(attacker, pushback_strength)
	
func pushback(attacker, pushback_strength : int):
	var direction : Vector2 = (attacker.global_position - global_position).normalized()
	direction = direction * pushback_strength
	await move_like_tween(direction, 100, 0.2, false, false)

func hit_effect():
	BODY.modulate = Color.WEB_MAROON
	await get_tree().create_timer(0.1).timeout
	BODY.modulate = Color.WHITE

