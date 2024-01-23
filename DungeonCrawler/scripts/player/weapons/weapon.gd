class_name Weapon extends Item

var weaponName : String;
var weaponMinDamage : int;
var weaponMaxDamage : int;
#todo tbd
var weaponKickback : int;
var weaponPushback : int;
var weaponPrice : int;
var weaponSprite : CompressedTexture2D;
var isWeaponRanged : bool;

func _init(
	nameWeapon : String, 
	minDamage : int, 
	maxDamage : int, 
	kickback : int, 
	pushback : int,
	price : int,
	sprite : CompressedTexture2D,
	ranged : bool) -> void:
	weaponName = nameWeapon;
	weaponMinDamage = minDamage;
	weaponMaxDamage = maxDamage;
	weaponKickback = kickback;
	weaponPushback = pushback;
	weaponPrice = price;
	weaponSprite = sprite;
	isWeaponRanged = ranged;
