class_name Bow extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/bow.png")

func _init() -> void: 
	super("Bow", 1, 3, 5, 2, 8, sprite, true, 4, .1)

