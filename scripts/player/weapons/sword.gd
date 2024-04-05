class_name Sword extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/sword.png")

func _init() -> void: 
	super("Sword", 1, 3, -4, 2, 10, sprite, false, 4, .1)
