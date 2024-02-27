class_name MailArmor extends Armor

var skinSprite : CompressedTexture2D = preload("res://assets/player/skins/mail.png")
var invSprite : CompressedTexture2D = preload("res://assets/armors/mail.png")

func _init() -> void: 
	super("Mail armor", 4, 6, .8, 15, invSprite, skinSprite, 15);
	
	#nameArmor : String,
	#minProt : int,
	#maxProt : int,
	#speedReducer : float,
	#priceArmor : int,
	#invSprite : CompressedTexture2D,
	#skinSprite : CompressedTexture2D,
	#weightArmor : int
