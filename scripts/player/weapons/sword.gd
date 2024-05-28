class_name Sword extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/sword.png")

func _init() -> void: 
	super(
		"Sword", 
		1, 
		3, 
		-4, 
		-6, 
		10, 
		sprite, 
		false, 
		4, 
		.1, 
		null, 
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
