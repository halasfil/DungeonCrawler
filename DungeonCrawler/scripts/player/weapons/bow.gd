class_name Bow extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/player/bow.png")

func _init() -> void: 
	super("Bow", 1, 3, "None", 2, 2, 10, sprite, true)
	
	#nameWeapon : String, 
	#minDamage : int, 
	#maxDamage : int, 
	#enchancement : String,
	#kickback : int, 
	#pushback : int,
	#price : int,
	#sprite : CompressedTexture2D,
	#ranged : bool
