class_name Armor extends Item

var protectionMin : int;
var protectionMax : int;
var walkingSpeedReducer : float;
var characterSkin : CompressedTexture2D;
var ARMOR_DETAILS_STRING_FORMAT : String = "Name: %s\nArmor: %s - %s\nPrice: %s\nKg: %s"

func _init(
	nameArmor : String,
	minProt : int,
	maxProt : int,
	speedReducer : float,
	priceArmor : int,
	invSprite : CompressedTexture2D,
	skinSprite : CompressedTexture2D,
	weightArmor : int):
	var minMaxArmor : String = "%s - %s" % [minProt, maxProt];
	var armorDescription : String = "Name: %s\nArmor: %s - %s\nPrice: %s\nKg: %s" % [nameArmor, minMaxArmor, priceArmor, weightArmor]
	super._init(nameArmor, priceArmor, weightArmor, invSprite, armorDescription);
	protectionMin = minProt;
	protectionMax = maxProt;
	characterSkin = skinSprite;
	walkingSpeedReducer = speedReducer;


#ITEM
#var itemName : String;
#var itemPrice : int;
#var itemWeight : int;
#var itemSprite : CompressedTexture2D;
#var itemDescription : String;
