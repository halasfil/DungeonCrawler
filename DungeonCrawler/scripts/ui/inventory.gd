class_name Inventory extends Control
#region global variables
enum ITEM_TYPE {
	WEAPON,
	ARMOR,
	UTIL
}
enum USE_BUTTON_STATES {
	USE,
	EQUIP,
	UNEQUIP,
	ASSIGN,
	UNASSIGN,
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
var EQUIP_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemActionButtons/EquipButton
@onready
var USE_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemActionButtons/UseButton

var USE_BUTTON_STATE : USE_BUTTON_STATES = USE_BUTTON_STATES.NEUTRAL;
var EQUIPPED_WEAPON : Weapon;
var EQUIPPED_ARMOR : Armor;
var EQUIPPED_ITEM : UtilItem;
var WEAPONS : Array[Item] = [Axe.new(), Bow.new(), Sword.new()]
var ARMORS : Array[Item];
var UTILS : Array[UtilItem];
var SHOWING_ITEM : Item;
var SHOWING_ITEM_TYPE : ITEM_TYPE;
var SHOWING_INDEX : int;
var LISTING_ITEMS_ARRAY : Array[Item];
var LISTING_ITEMS_TYPE : ITEM_TYPE;
#endregion
func _on_exit_button_down():
	self.visible = false
	
func open_inventory_window():
	clear_selected()
	clear_equipment()
	choose_weapons_to_list()
	show_items()
	
func choose_weapons_to_list():
	LISTING_ITEMS_ARRAY = WEAPONS
	LISTING_ITEMS_TYPE = ITEM_TYPE.WEAPON
	
func clear_selected():
	ITEM_TEXTURE.texture = null
	ITEM_DETAILS.text = ""
	ITEM_ACTION_BUTTONS.visible = false

func clear_equipment():
	for n in ITEM_LIST_CONTAINER.get_children():
		ITEM_LIST_CONTAINER.remove_child(n)
		n.queue_free()
		
func show_items():
	for i in LISTING_ITEMS_ARRAY.size():
		var inventoryItem = InventoryItem.new(LISTING_ITEMS_ARRAY[i].itemName, i, ITEM_TYPE.WEAPON)
		inventoryItem.pressed.connect(show_clicked_item_details)
		ITEM_LIST_CONTAINER.add_child(inventoryItem)
		if (LISTING_ITEMS_ARRAY[i] == EQUIPPED_WEAPON || LISTING_ITEMS_ARRAY[i] == EQUIPPED_ARMOR):
			inventoryItem.text = LISTING_ITEMS_ARRAY[i].itemName + " - equipped"
		elif (LISTING_ITEMS_ARRAY[i] == EQUIPPED_ITEM):
			inventoryItem.text = LISTING_ITEMS_ARRAY[i].itemName + " - hotkey"
		else:
			inventoryItem.text = LISTING_ITEMS_ARRAY[i].itemName
	
func show_clicked_item_details():
	if (ITEM_LIST_CONTAINER.get_child_count() > 0):
		var pressedItems = ITEM_LIST_CONTAINER.get_children().filter(
			func(node): return node.clicked != false)
		if (!pressedItems.is_empty()):
			var inventoryItem : InventoryItem = pressedItems[0]
			show_item_details(inventoryItem)

func show_item_details(inventoryItem : InventoryItem):
	ITEM_ACTION_BUTTONS.visible = true
	SHOWING_INDEX = inventoryItem.inventoryIndex
	SHOWING_ITEM = LISTING_ITEMS_ARRAY[SHOWING_INDEX]
	SHOWING_ITEM_TYPE = inventoryItem.type
	#if weapon
	if (inventoryItem.type == ITEM_TYPE.WEAPON || inventoryItem.type == ITEM_TYPE.ARMOR):
		USE_BUTTON.visible = false
	else:
		USE_BUTTON.visible = true
	ITEM_TEXTURE.texture = SHOWING_ITEM.itemSprite
	ITEM_DETAILS.text = SHOWING_ITEM.itemDescription
	change_equip_button_label()

func change_equip_button_label():
	if (SHOWING_ITEM && 
	((EQUIPPED_WEAPON && EQUIPPED_WEAPON == SHOWING_ITEM) 
	|| (EQUIPPED_ARMOR && EQUIPPED_ARMOR == SHOWING_ITEM)
	|| (EQUIPPED_ITEM && EQUIPPED_ITEM == SHOWING_ITEM)
	)):
		if SHOWING_ITEM_TYPE == ITEM_TYPE.UTIL:
			EQUIP_BUTTON.text = "Unassign"
		else:
			EQUIP_BUTTON.text = "Unequip"
			USE_BUTTON_STATE = USE_BUTTON_STATES.UNEQUIP
	else:
		if SHOWING_ITEM_TYPE == ITEM_TYPE.UTIL:
			EQUIP_BUTTON.text = "Assign"
		else:
			EQUIP_BUTTON.text = "Equip"
			USE_BUTTON_STATE = USE_BUTTON_STATES.EQUIP

func unmark_buttons():
	clear_equipment()
	show_items()
	
func mark_equipped_button():
	var equipped_button_node = ITEM_LIST_CONTAINER.get_child(SHOWING_INDEX)
	equipped_button_node.text = SHOWING_ITEM.itemName + " - equipped"

func _on_delete_button_pressed():
	#if weapons
	if (EQUIPPED_WEAPON == SHOWING_ITEM):
		EQUIPPED_WEAPON = null
	WEAPONS = WEAPONS.filter(
		func(node): 
			return node.itemName != SHOWING_ITEM.itemName)
	open_inventory_window()

func _on_equip_button_pressed():
	#if weapon
	if (USE_BUTTON_STATE == USE_BUTTON_STATES.EQUIP):
		EQUIPPED_WEAPON = SHOWING_ITEM
		unmark_buttons();
		mark_equipped_button()
		change_equip_button_label()
	else:
		EQUIPPED_WEAPON = null
		unmark_buttons();
		change_equip_button_label()
