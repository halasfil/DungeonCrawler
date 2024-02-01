class_name Axe extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/axe.png")

func _init() -> void: 
	super("Axe", 1, 4, -5, 2, 5, sprite, false, 5)
	
	#nameWeapon : String, 
	#minDamage : int, 
	#maxDamage : int, 
	#kickback : int, 
	#pushback : int,
	#price : int,
	#sprite : CompressedTexture2D
	#ranged : bool
	#weight: int
