class_name Projectile extends CharacterBody2D

enum STATES {
	FLYING,
	DESTROYED
}

@onready
var ANIMATION_PLAYER : AnimationPlayer = $AnimationPlayer
@onready
var STATE : STATES = STATES.FLYING;

func _ready():
	print("spawns")
#
func fly():
	ANIMATION_PLAYER.play("idle")
	move_and_collide(velocity)

func destroy():
	STATE = STATES.DESTROYED
	ANIMATION_PLAYER.play("destroy")
	await ANIMATION_PLAYER.animation_finished
	queue_free()

func _physics_process(_delta) -> void:
	if (STATE == STATES.FLYING):
		fly()
	else:
		destroy()
	
func _on_timer_timeout():
	STATE = STATES.DESTROYED

func _on_area_2d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if (area.name == "hitbox"):
		destroy()


func _on_area_2d_body_entered(body):
	if (body is TileMap):
		destroy()

