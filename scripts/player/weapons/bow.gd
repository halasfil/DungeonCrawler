class_name Bow extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/bow.png")
var projectile : CompressedTexture2D = preload("res://assets/weapons/arrow.png")
var bowLine : CompressedTexture2D = preload("res://assets/weapons/bow_line.png")

func _init() -> void: 
	super("Bow", 1, 3, 5, -2, 8, sprite, true, 4, .1, projectile, bowLine)


	#nameWeapon : String, 
	#minDamage : int, 
	#maxDamage : int, 
	#kickback : int, 
	#pushback : int,
	#priceWeapon : int,
	#sprite : CompressedTexture2D,
	#ranged : bool,
	#weightWeapon : int,
	#anticipationTime : float,
	#projectile_sprite : CompressedTexture2D
