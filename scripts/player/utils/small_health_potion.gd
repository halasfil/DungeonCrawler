class_name SmallHealthPotion extends UtilItem

var sprite : CompressedTexture2D = preload("res://assets/utils/small_health_potion.png")

func _init() -> void: 
	super(
		"Small health potion", 
		10, 
		UTIL_TYPE.HEALING, 
		9, 
		sprite,
		1);

	#nameItem : String,
	#power : int,
	#type : UTIL_TYPE,
	#priceUtil : int,
	#sprite : CompressedTexture2D,
	#weight : int
