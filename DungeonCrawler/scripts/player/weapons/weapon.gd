class_name Weapon extends Item

var weaponMinDamage : int;
var weaponMaxDamage : int;
var weaponKickback : int;
var weaponPushback : int;
var isWeaponRanged : bool;

func _init(
	nameWeapon : String, 
	minDamage : int, 
	maxDamage : int, 
	kickback : int, 
	pushback : int,
	priceWeapon : int,
	sprite : CompressedTexture2D,
	ranged : bool,
	weightWeapon : int):
	var mixMaxDmg : String = "%s - %s" % [weaponMinDamage, weaponMaxDamage]
	var weaponDescription : String = "Name: %s\nDmg: %s\nPrice: %s\nKg: %s" % [nameWeapon, mixMaxDmg, priceWeapon, weightWeapon]
	super._init(nameWeapon, priceWeapon, weightWeapon, sprite, weaponDescription);
	weaponMinDamage = minDamage;
	weaponMaxDamage = maxDamage;
	weaponKickback = kickback;
	weaponPushback = pushback;
	isWeaponRanged = ranged;
#
#func _init(
	#nameWeapon : String, 
	#minDamage : int, 
	#maxDamage : int, 
	#kickback : int, 
	#pushback : int,
	#price : int,
	#sprite : CompressedTexture2D,
	#ranged : bool):
	#weaponName = nameWeapon;
	#weaponMinDamage = minDamage;
	#weaponMaxDamage = maxDamage;
	#weaponKickback = kickback;
	#weaponPushback = pushback;
	#weaponPrice = price;
	#weaponSprite = sprite;
	#isWeaponRanged = ranged;
