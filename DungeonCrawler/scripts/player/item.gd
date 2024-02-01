class_name Item extends Node

var itemName : String;
var itemPrice : int;
var itemWeight : int;
var itemSprite : CompressedTexture2D;
var itemDescription : String;

func _init(item_name : String, item_price : int, item_weight : int, item_sprite : CompressedTexture2D, item_description : String):
	itemName = item_name;
	itemPrice = item_price;
	itemWeight = item_weight;
	itemSprite = item_sprite;
	itemDescription = item_description;
