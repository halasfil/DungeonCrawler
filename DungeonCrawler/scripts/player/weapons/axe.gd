class_name Axe extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/player/axe.png")


func _init() -> void: 
	super("Axe", 1, 3, "None", -5, 2, 10, sprite, false)
	
	#nameWeapon : String, 
	#minDamage : int, 
	#maxDamage : int, 
	#enchancement : String,
	#kickback : int, 
	#pushback : int,
	#price : int,
	#sprite : CompressedTexture2D
	#ranged : bool
