class_name Drop extends Node2D

enum DROP_TYPES {
	HEALTH,
	COIN
}

var TYPE : DROP_TYPES
var STRENGTH : int
@onready
var ANIMATION : AnimationPlayer = $AnimationPlayer
@onready
var SPRITE : Sprite2D = $Sprite2d
@onready
var LIGHT : PointLight2D = $Sprite2d/light

func _ready():
	ANIMATION.play("idle")
	if (TYPE == DROP_TYPES.HEALTH):
		LIGHT.color = Color(.98,1,1,1)
		SPRITE.texture = preload("res://assets/drops/health.png")
	if (TYPE == DROP_TYPES.COIN):	
		LIGHT.color = Color(.98,1,0,1)
		SPRITE.texture = preload("res://assets/drops/coin.png")


func _on_area_2d_body_entered(body):
	if (body is Player):
		ANIMATION.play("take")
		await ANIMATION.animation_finished
		body.add_drop(TYPE, STRENGTH)
		queue_free()

