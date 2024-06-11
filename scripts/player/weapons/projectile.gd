class_name Projectile extends CharacterBody2D

enum STATES {
	FLYING,
	DESTROYED
}

@onready
var ANIMATION_PLAYER: AnimationPlayer = $AnimationPlayer
@onready
var STATE: STATES = STATES.FLYING;
@onready
var LIGHT: PointLight2D = $PointLight2D
var PROJECTILE : ProjectileModel
@onready
var SKIN: Sprite2D = $Sprite2D
@onready
var PROJECTILE_SPRITE: CompressedTexture2D = preload ("res://assets/weapons/arrow.png")
var SHOOTER: Node

func _ready():
	add_collision_exception_with(self)
	var randomizer: RandomNumberGenerator = RandomNumberGenerator.new();
	randomizer.randomize()
	var energyStrength: float = randomizer.randf_range(0.1, 0.7)
	LIGHT.energy = energyStrength

func _physics_process(_delta) -> void:
	if (STATE == STATES.FLYING):
		fly()
	else:
		destroy()
	
func fly():
	SKIN.texture = PROJECTILE_SPRITE
	ANIMATION_PLAYER.play("idle")
	move_and_collide(velocity)

func destroy():
	LIGHT.energy = 0
	STATE = STATES.DESTROYED
	ANIMATION_PLAYER.play("destroy")
	await ANIMATION_PLAYER.animation_finished
	queue_free()

func _on_timer_timeout():
	STATE = STATES.DESTROYED

func _on_area_2d_body_entered(body):
	if (body is TileMap):
		destroy()
	if (body.has_method("take_damage")):
		destroy()
		if (SHOOTER && SHOOTER != body && !friendly_fire_check(body)):
			body.take_damage(PROJECTILE.minDamage, PROJECTILE.maxDamage, PROJECTILE.weaponPushback, self)

func friendly_fire_check(body):
	return SHOOTER is BasicEnemy && body is BasicEnemy
