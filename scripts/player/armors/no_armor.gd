class_name NoArmor extends Armor

var skinSprite : CompressedTexture2D = preload("res://assets/player/skins/no_armor.png")
var invSprite : CompressedTexture2D = null

func _init() -> void: 
	super("No armor", 0, 1, 1, 0, invSprite, skinSprite, 0);
	
	#nameArmor : String,
	#minProt : int,
	#maxProt : int,
	#speedReducer : float,
	#priceArmor : int,
	#invSprite : CompressedTexture2D,
	#skinSprite : CompressedTexture2D,
	#weightArmor : int
