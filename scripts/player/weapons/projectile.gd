class_name Projectile extends CharacterBody2D

enum STATES {
	FLYING,
	DESTROYED
}

@onready
var ANIMATION_PLAYER : AnimationPlayer = $AnimationPlayer
@onready
var STATE : STATES = STATES.FLYING;
@onready
var LIGHT : PointLight2D = $PointLight2D
@onready
var MAX_DAMAGE : int = 1;
@onready
var MIN_DAMAGE : int = 1;
@onready
var PUSHBACK_STRENGTH : int = 1;
@onready
var SKIN : Sprite2D = $Sprite2D
@onready
var PROJECTILE_SPRITE : CompressedTexture2D = preload("res://assets/weapons/arrow.png")

func _ready():
	add_collision_exception_with(self)
	var energyStrength : float = RandomNumberGenerator.new().randf_range(0.1, 0.7)
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
	move_and_collide(velocity)
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
	if (body is BasicEnemy && body.has_method("take_damage")):
		destroy()
		body.take_damage(MIN_DAMAGE, MAX_DAMAGE, PUSHBACK_STRENGTH)
