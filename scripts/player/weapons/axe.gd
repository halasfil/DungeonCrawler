class_name Axe extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/axe.png")

func _init() -> void: 
	super(
	"Axe", 
	1, 
	4, 
	-10, 
	-12, 
	5, 
	sprite, 
	false, 
	5, 
	.15, 
	null)

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
