class_name Inventory extends Control

enum ITEM_TYPE {
	WEAPON,
	ARMOR,
	UTIL
}
enum USE_BUTTON_STATES {
	USE,
	EQUIP,
	UNEQUIP,
	NEUTRAL
}
@onready
var ITEM_LIST_CONTAINER : VBoxContainer= $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ItemsList
@onready
var ITEM_DETAILS_CONTAINER : VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer
@onready
var ITEM_TEXTURE : TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/TextureRect
@onready
var ITEM_DETAILS : RichTextLabel= $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemDetails
@onready
var ITEM_ACTION_BUTTONS : HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemActionButtons
@onready
var USE_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemActionButtons/UseButton

var ITEM_DETAILS_STRING_FORMAT = "Name: %s\nDmg: %s\nPrice: %s\nKg: %s"

var USE_BUTTON_STATE = USE_BUTTON_STATES.NEUTRAL;
var EQUIPPED_WEAPON : Weapon;
var EQUIPPED_ARMOR;
var WEAPONS : Array[Weapon] = [Axe.new(), Bow.new(), Sword.new()]
var ARMORS;
var UTILS;
var SHOWING_ITEM;
var SHOWING_INDEX;

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
		var inventoryItem = InventoryItem.new(WEAPONS[i].weaponName, i, ITEM_TYPE.WEAPON)
		ITEM_LIST_CONTAINER.add_child(inventoryItem)
	
func process_item_clicked():
	if (ITEM_LIST_CONTAINER.get_child_count() > 0):
		var pressedItems = ITEM_LIST_CONTAINER.get_children().filter(
			func(node): return node.clicked != false)
		if (!pressedItems.is_empty()):
			show_item_details(pressedItems)
	
func change_use_button_label():
	if (SHOWING_ITEM && EQUIPPED_WEAPON && EQUIPPED_WEAPON == SHOWING_ITEM):
		USE_BUTTON.text = "Unequip"
		USE_BUTTON_STATE = USE_BUTTON_STATES.UNEQUIP
	else:
		USE_BUTTON.text = "Equip"
		USE_BUTTON_STATE = USE_BUTTON_STATES.EQUIP

func show_item_details(pressedItems):
	#if weaponw
	ITEM_ACTION_BUTTONS.visible = true
	var pressedItem = WEAPONS[pressedItems[0].inventoryIndex]
	SHOWING_ITEM = pressedItem
	SHOWING_INDEX = pressedItems[0].inventoryIndex
	ITEM_TEXTURE.texture = pressedItem.weaponSprite
	var mixMaxDmg = "%s - %s" % [pressedItem.weaponMinDamage, pressedItem.weaponMaxDamage]
	ITEM_DETAILS.text = ITEM_DETAILS_STRING_FORMAT % [pressedItem.weaponName, mixMaxDmg, pressedItem.weaponPrice, 10]
	change_use_button_label()

func _on_use_button_pressed():
	#if weapon
	if (USE_BUTTON_STATE == USE_BUTTON_STATES.EQUIP):
		unmark_buttons();
		mark_equipped_button()
		EQUIPPED_WEAPON = SHOWING_ITEM
		change_use_button_label()
	else:
		unmark_buttons();
		EQUIPPED_WEAPON = null
		change_use_button_label()
	
func unmark_buttons():
	clear_equipment()
	show_weapons()
	
func mark_equipped_button():
	var equipped_button_node = ITEM_LIST_CONTAINER.get_child(SHOWING_INDEX)
	equipped_button_node.text = SHOWING_ITEM.weaponName + " - equipped"

func _on_delete_button_pressed():
	print("delete")
