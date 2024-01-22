class_name Inventory extends Control

enum ITEM_TYPES {
	WEAPON,
	ARMOR,
	UTILS
}

@onready
var ITEM_LIST_CONTAINER :VBoxContainer= $VBoxContainer/HBoxContainer/ItemsList
@onready
var ITEM_DETAILS_CONTAINER :VBoxContainer = $VBoxContainer/HBoxContainer/ItemDetailsContainer
@onready
var ITEM_TEXTURE :TextureRect = $VBoxContainer/HBoxContainer/ItemDetailsContainer/TextureRect
@onready
var ITEM_DETAILS :RichTextLabel= $VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemDetails

var ITEM_DETAILS_STRING_FORMAT = "Name: %s\nDmg: %s\nPrice: %s\nKg: %s"

var WEAPONS : Array[Weapon] = [Axe.new(), Bow.new(), Sword.new()]
var SHOW_ITEM_FOR_DETAILS;

func _on_exit_button_down():
	self.visible = false

func _ready():
	ITEM_DETAILS_CONTAINER.visible = false
	display_equipment()
	
func display_equipment():
	#if jestesmy w weapons. dodaj elsy
	for i in WEAPONS.size():
		var inventoryItem = InventoryItem.new(WEAPONS[i].weaponName, i)
		ITEM_LIST_CONTAINER.add_child(inventoryItem)

func _process(_delta):
	if (ITEM_LIST_CONTAINER.get_child_count() > 0):
		var pressedItems = ITEM_LIST_CONTAINER.get_children().filter(
			func(node): return node.clicked != false)
		if (!pressedItems.is_empty()):
			ITEM_DETAILS_CONTAINER.visible = true
			SHOW_ITEM_FOR_DETAILS = WEAPONS[pressedItems[0].inventoryIndex]
			ITEM_TEXTURE.texture = SHOW_ITEM_FOR_DETAILS.weaponSprite
			var mixMaxDmg = "%s - %s" % [
				SHOW_ITEM_FOR_DETAILS.weaponMinDamage, SHOW_ITEM_FOR_DETAILS.weaponMaxDamage]
			ITEM_DETAILS.text = ITEM_DETAILS_STRING_FORMAT % [
				SHOW_ITEM_FOR_DETAILS.weaponName, mixMaxDmg, SHOW_ITEM_FOR_DETAILS.weaponPrice, 10]
			
