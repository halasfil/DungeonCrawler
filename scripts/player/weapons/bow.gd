class_name Bow extends Weapon

var sprite : CompressedTexture2D = preload("res://assets/weapons/bow.png")
var mindmg : int = 1
var maxdmg : int = 3
var push : int = -2

var projectile : ProjectileModel = ProjectileModel.new(
	preload("res://assets/weapons/arrow.png"),
	mindmg,
	maxdmg,
	push,
	1.0)
	
func _init() -> void: 
	super("Bow", mindmg, maxdmg, 5, push, 8, sprite, true, 4, .1, projectile)
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
