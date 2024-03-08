class_name UtilItem extends Item

enum UTIL_TYPE {
	HEALING,
};
var itemPower : int;
var itemType : UTIL_TYPE;

func _init(
	nameItem : String,
	power : int,
	type : UTIL_TYPE,
	priceUtil : int,
	sprite : CompressedTexture2D,
	weight : int):
	var utilDescription : String = "Name: %s\nPower: %s\nPrice: %s\nKg: %s" % [nameItem, power, priceUtil, weight]
	super._init(nameItem, priceUtil, weight, sprite, utilDescription);
	itemPower = power;
	itemType = type;
