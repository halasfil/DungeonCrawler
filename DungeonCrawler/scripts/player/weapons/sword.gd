class_name Sword extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/player/sword.png")


func _init() -> void: 
	super("Sword", 1, 3, "None", -2, 2, 10, sprite, false)
	
	#nameWeapon : String, 
	#minDamage : int, 
	#maxDamage : int, 
	#enchancement : String,
	#kickback : int, 
	#pushback : int,
	#price : int,
	#sprite : CompressedTexture2D
	#ranged : bool
