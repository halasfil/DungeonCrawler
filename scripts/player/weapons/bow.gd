class_name Bow extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/bow.png")

func _init() -> void: 
	super("Bow", 1, 3, 2, 2, 8, sprite, true, 4)
	
	#nameWeapon : String, 
	#minDamage : int, 
	#maxDamage : int, 
	#kickback : int, 
	#pushback : int,
	#price : int,
	#sprite : CompressedTexture2D,
	#ranged : bool
	#weight: int
