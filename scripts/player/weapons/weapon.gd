class_name Weapon extends Item

var weaponMinDamage : int;
var weaponMaxDamage : int;
var weaponKickback : int;
var weaponPushback : int;
var isWeaponRanged : bool;
var weaponAnticipationTime : float;
var projectileModel : ProjectileModel;

func _init(
	nameWeapon : String, 
	minDamage : int, 
	maxDamage : int, 
	kickback : int, 
	pushback : int,
	priceWeapon : int,
	sprite : CompressedTexture2D,
	ranged : bool,
	weightWeapon : int,
	anticipationTime : float,
	projectile : ProjectileModel):
	var mixMaxDmg : String = "%s - %s" % [minDamage, maxDamage]
	var weaponDescription : String = "Name: %s\nDmg: %s\nPrice: %s\nKg: %s" % [nameWeapon, mixMaxDmg, priceWeapon, weightWeapon]
	super._init(nameWeapon, priceWeapon, weightWeapon, sprite, weaponDescription);
	weaponMinDamage = minDamage;
	weaponMaxDamage = maxDamage;
	weaponKickback = kickback;
	weaponPushback = pushback;
	isWeaponRanged = ranged;
	weaponAnticipationTime = anticipationTime;
	projectileModel = projectile;
