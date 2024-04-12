class_name Axe extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/axe.png")

func _init() -> void: 
	super("Axe", 1, 4, -10, 2, 5, sprite, false, 5, .15, null)
