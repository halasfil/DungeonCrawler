class_name Weapon extends Node

var weaponName : String;
var weaponMinDamage : int;
var weaponMaxDamage : int;
#todo tbd
var weaponEnchancement : String;
var weaponKickback : int;
var weaponPushback : int;
var weaponPrice : int;
var weaponSprite : CompressedTexture2D;
var isWeaponRanged : bool;

func _init(
	nameWeapon : String, 
	minDamage : int, 
	maxDamage : int, 
	enchancement : String,
	kickback : int, 
	pushback : int,
	price : int,
	sprite : CompressedTexture2D,
	ranged : bool) -> void:
		
	weaponName = nameWeapon;
	weaponMinDamage = minDamage;
	weaponMaxDamage = maxDamage;
	weaponEnchancement = enchancement;
	weaponKickback = kickback;
	weaponPushback = pushback;
	weaponPrice = price;
	weaponSprite = sprite;
	isWeaponRanged = ranged;
