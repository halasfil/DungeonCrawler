class_name Inventory extends Control

enum ITEM_TYPES {
	WEAPON,
	ARMOR,
	UTILS
}
@onready
var ITEM_LIST_CONTAINER : VBoxContainer= $VBoxContainer/HBoxContainer/ScrollContainer/ItemsList
@onready
var ITEM_DETAILS_CONTAINER : VBoxContainer = $VBoxContainer/HBoxContainer/ItemDetailsContainer
@onready
var ITEM_TEXTURE : TextureRect = $VBoxContainer/HBoxContainer/ItemDetailsContainer/TextureRect
@onready
var ITEM_DETAILS : RichTextLabel= $VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemDetails
@onready
var ITEM_ACTION_BUTTONS : HBoxContainer = $VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemActionButtons

var ITEM_DETAILS_STRING_FORMAT = "Name: %s\nDmg: %s\nPrice: %s\nKg: %s"

var EQUIPPED_WEAPON : Weapon
var EQUIPPED_ARMOR
var WEAPONS : Array[Weapon] = [Axe.new(), Bow.new(), Sword.new()]
var ARMORS;
var UTILS;
var SHOWING_ITEM;
var SHOWING_INDEX

func open() -> void:
	open_equipment_window()
	
func _on_exit_button_down():
	self.visible = false
	
func _ready():
	show_weapons()
	
func _process(_delta):
	process_item_clicked()
	
func clear_equipment():
	for n in ITEM_LIST_CONTAINER.get_children():
		ITEM_LIST_CONTAINER.remove_child(n)
		n.queue_free()
	
func clear_selected():
	ITEM_TEXTURE.texture = null
	ITEM_DETAILS.text = ""
	ITEM_ACTION_BUTTONS.visible = false
	
func open_equipment_window():
	clear_selected()
	
func show_weapons():
	for i in WEAPONS.size():
		var inventoryItem = InventoryItem.new(WEAPONS[i].weaponName, i)
		ITEM_LIST_CONTAINER.add_child(inventoryItem)
	
func process_item_clicked():
	if (ITEM_LIST_CONTAINER.get_child_count() > 0):
		var pressedItems = ITEM_LIST_CONTAINER.get_children().filter(
			func(node): return node.clicked != false)
		if (!pressedItems.is_empty()):
			show_item_details(pressedItems)
	
func show_item_details(pressedItems):
	ITEM_ACTION_BUTTONS.visible = true
	var pressedItem = WEAPONS[pressedItems[0].inventoryIndex]
	SHOWING_ITEM = pressedItem
	SHOWING_INDEX = pressedItems[0].inventoryIndex
	ITEM_TEXTURE.texture = pressedItem.weaponSprite
	var mixMaxDmg = "%s - %s" % [pressedItem.weaponMinDamage, pressedItem.weaponMaxDamage]
	ITEM_DETAILS.text = ITEM_DETAILS_STRING_FORMAT % [pressedItem.weaponName, mixMaxDmg, pressedItem.weaponPrice, 10]

func _on_use_button_pressed():
	#if weapon
	unmark_buttons();
	mark_equipped_button()
	EQUIPPED_WEAPON = SHOWING_ITEM
	print(EQUIPPED_WEAPON.weaponName)
	
func unmark_buttons():
	clear_equipment()
	show_weapons()
	
func mark_equipped_button():
	var equipped_button_node = ITEM_LIST_CONTAINER.get_child(SHOWING_INDEX)
	equipped_button_node.text = SHOWING_ITEM.weaponName + " - equipped"
