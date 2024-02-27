class_name LeatherArmor extends Armor

var skinSprite : CompressedTexture2D = preload("res://assets/player/skins/leather.png")
var invSprite : CompressedTexture2D = preload("res://assets/armors/leather.png")

func _init() -> void: 
	super("Leather armor", 1, 3, .9, 10, invSprite, skinSprite, 10);
	
	#nameArmor : String,
	#minProt : int,
	#maxProt : int,
	#speedReducer : float,
	#priceArmor : int,
	#invSprite : CompressedTexture2D,
	#skinSprite : CompressedTexture2D,
	#weightArmor : int
