class_name MailArmor extends Armor

var skinSprite : CompressedTexture2D = preload("res://assets/player/skins/mail.png")
var invSprite : CompressedTexture2D = preload("res://assets/armors/mail.png")

func _init() -> void: 
	super("Mail armor", 4, 6, 
	#walkingSpeedReducer
	.8, 15, invSprite, skinSprite, 15);
	
	
