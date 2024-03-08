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
enum CONFIRM_ACTION_TYPE {
	DELETE,
	SELL
}
@onready
var ITEM_LIST_CONTAINER : VBoxContainer= $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ItemsList
@onready
var ITEM_DETAILS_CONTAINER : VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer
@onready
var ITEM_TEXTURE : TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ColorRect/ColorRect/TextureRect
@onready
var ITEM_DETAILS : RichTextLabel= $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemDetails
@onready
var ITEM_ACTION_BUTTONS : HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemActionButtons
@onready
var EQUIP_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemActionButtons/EquipButton
@onready
var USE_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ItemActionButtons/UseButton
@onready
var COLOR_RECT_BACKGROUND : TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ColorRect
@onready
var CONFIRM_PANEL : HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ConfirmPanel
@onready
var CONFIRM_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ConfirmPanel/Confirm_button
@onready
var CANCEL_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ItemDetailsContainer/ConfirmPanel/Cancel_button
@onready
var WEAPONS_CATEGORY_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/TypeChoice/Weapons
@onready
var ARMORS_CATEGORY_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/TypeChoice/Armors
@onready
var UTILS_CATEGORY_BUTTON : Button = $PanelContainer/MarginContainer/VBoxContainer/TypeChoice/Utils
@onready
var GOLD_LABEL : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Gold
@onready
var WEIGHT_LABEL : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Weight

var USE_BUTTON_STATE : USE_BUTTON_STATES = USE_BUTTON_STATES.NEUTRAL;
var SHOWING_ITEM : Item;
var SHOWING_ITEM_TYPE : ITEM_TYPE;
var SHOWING_ITEM_INDEX : int;
var LISTING_ITEMS_ARRAY : Array[Item];
var LISTING_ITEMS_TYPE : ITEM_TYPE;
var CONFIRM_ACTION : CONFIRM_ACTION_TYPE;
#todo connect this to some global script in the future
var GOLD : int;
var WEIGHT : int;
var MAX_WEIGHT : int = 100;
var EQUIPPED_WEAPON : Weapon;
var EQUIPPED_ARMOR : Armor;
var HOTKEY_UTIL : UtilItem;
var WEAPONS : Array[Item] = [Axe.new(), Bow.new(), Sword.new()]
var ARMORS : Array[Item] = [LeatherArmor.new(), MailArmor.new()];
var UTILS : Array[Item] = [SmallHealthPotion.new()];
#endregion
#region open close inventory
func open_inventory_window():
	clear_selected()
	clear_equipment()
	set_weapons_to_show_in_list()
	show_items_in_list()
	calculate_gold()
	calculate_weight()
func _on_exit_button_down():
	CONFIRM_PANEL.visible = false
	self.visible = false
func refresh_equipment():
	clear_equipment()
	show_items_in_list()
func reload_equipment():
	clear_selected()
	clear_equipment()
	if (SHOWING_ITEM_TYPE == ITEM_TYPE.WEAPON):
		set_weapons_to_show_in_list()
	elif (SHOWING_ITEM_TYPE == ITEM_TYPE.ARMOR):
		set_armors_to_show_in_list()
	else:
		set_utils_to_show_in_list()
	show_items_in_list()
	calculate_gold()
	calculate_weight()
#endregion
#region category change
func handle_weapons_category_click():
	clear_selected()
	clear_equipment()
	set_weapons_to_show_in_list()
	show_items_in_list()
func handle_armors_category_click():
	clear_selected()
	clear_equipment()
	set_armors_to_show_in_list()
	show_items_in_list()
func handle_utils_category_click():
	clear_selected()
	clear_equipment()
	set_utils_to_show_in_list()
	show_items_in_list()
#endregion
#region show items
func set_weapons_to_show_in_list():
	LISTING_ITEMS_ARRAY = WEAPONS
	LISTING_ITEMS_TYPE = ITEM_TYPE.WEAPON
func set_armors_to_show_in_list():
	LISTING_ITEMS_ARRAY = ARMORS
	LISTING_ITEMS_TYPE = ITEM_TYPE.ARMOR
func set_utils_to_show_in_list():
	LISTING_ITEMS_ARRAY = UTILS
	LISTING_ITEMS_TYPE = ITEM_TYPE.UTIL
func show_items_in_list():
	for i in LISTING_ITEMS_ARRAY.size():
		var inventoryItem = InventoryItem.new(LISTING_ITEMS_ARRAY[i].itemName, i, LISTING_ITEMS_TYPE)
		inventoryItem.pressed.connect(show_clicked_item_details)
		ITEM_LIST_CONTAINER.add_child(inventoryItem)
		add_equipped_or_hotkey_label_to_button_name(i, inventoryItem)
func add_equipped_or_hotkey_label_to_button_name(i : int, inventoryItem : InventoryItem):
	if (LISTING_ITEMS_ARRAY[i] == EQUIPPED_WEAPON || LISTING_ITEMS_ARRAY[i] == EQUIPPED_ARMOR):
		inventoryItem.text = LISTING_ITEMS_ARRAY[i].itemName + " - equipped"
	elif (LISTING_ITEMS_ARRAY[i] == HOTKEY_UTIL):
		inventoryItem.text = LISTING_ITEMS_ARRAY[i].itemName + " - hotkey"
	else:
		inventoryItem.text = LISTING_ITEMS_ARRAY[i].itemName
func show_clicked_item_details():
	if (ITEM_LIST_CONTAINER.get_child_count() > 0):
		var pressedItems = ITEM_LIST_CONTAINER.get_children().filter(
			func(node): return node.clicked != false)
		if (!pressedItems.is_empty()):
			var clickedItemFromInventory : InventoryItem = pressedItems[0]
			show_item_details(clickedItemFromInventory)
func show_item_details(clickedItemFromInventory : InventoryItem):
	CONFIRM_PANEL.visible = false
	ITEM_ACTION_BUTTONS.visible = true
	COLOR_RECT_BACKGROUND.visible = true
	SHOWING_ITEM_INDEX = clickedItemFromInventory.inventoryIndex
	SHOWING_ITEM = LISTING_ITEMS_ARRAY[SHOWING_ITEM_INDEX]
	SHOWING_ITEM_TYPE = clickedItemFromInventory.type
	ITEM_TEXTURE.texture = SHOWING_ITEM.itemSprite
	ITEM_DETAILS.text = SHOWING_ITEM.itemDescription
	if (clickedItemFromInventory.type == ITEM_TYPE.WEAPON || clickedItemFromInventory.type == ITEM_TYPE.ARMOR):
		USE_BUTTON.visible = false
	else:
		USE_BUTTON.visible = true
	change_equip_button_label()
func change_equip_button_label():
	if (SHOWING_ITEM && 
	(
		(EQUIPPED_WEAPON && EQUIPPED_WEAPON == SHOWING_ITEM) 
		|| (EQUIPPED_ARMOR && EQUIPPED_ARMOR == SHOWING_ITEM)
		|| (HOTKEY_UTIL && HOTKEY_UTIL == SHOWING_ITEM)
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
#endregion
#region clearing
func clear_selected():
	ITEM_TEXTURE.texture = null
	ITEM_DETAILS.text = ""
	ITEM_ACTION_BUTTONS.visible = false
	COLOR_RECT_BACKGROUND.visible = false
func clear_equipment():
	for n in ITEM_LIST_CONTAINER.get_children():
		ITEM_LIST_CONTAINER.remove_child(n)
		n.queue_free()
#endregion
#region button actions
func sell_delete_confirm_action():
	CONFIRM_PANEL.visible = false
	if (CONFIRM_ACTION == CONFIRM_ACTION_TYPE.DELETE):
		delete_item_action()
	if (CONFIRM_ACTION == CONFIRM_ACTION_TYPE.SELL):
		sell_item_action()
	reload_equipment()
	
func delete_item_action():
	if (EQUIPPED_WEAPON == SHOWING_ITEM):
		EQUIPPED_WEAPON = null
	if (EQUIPPED_ARMOR == SHOWING_ITEM):
		EQUIPPED_ARMOR = null
	if (HOTKEY_UTIL == SHOWING_ITEM):
		HOTKEY_UTIL = null
	if (SHOWING_ITEM_TYPE == ITEM_TYPE.WEAPON):
		WEAPONS = WEAPONS.filter(
			func(node): 
				return node.itemName != SHOWING_ITEM.itemName)
	if (SHOWING_ITEM_TYPE == ITEM_TYPE.ARMOR):
		ARMORS = ARMORS.filter(
			func(node): 
				return node.itemName != SHOWING_ITEM.itemName)
	if (SHOWING_ITEM_TYPE == ITEM_TYPE.UTIL):
		UTILS = UTILS.filter(
			func(node): 
				return node.itemName != SHOWING_ITEM.itemName)
func sell_item_action():
	#todo - selling function
	print("sell action confirmed")
func cancel_action():
	CONFIRM_PANEL.visible = false;
	ITEM_ACTION_BUTTONS.visible = true;
func _on_delete_button_pressed():
	show_confirmation_panel(CONFIRM_ACTION_TYPE.DELETE)
func _on_equip_button_pressed():
	if (SHOWING_ITEM_TYPE == ITEM_TYPE.WEAPON):
		if (USE_BUTTON_STATE == USE_BUTTON_STATES.EQUIP):
			EQUIPPED_WEAPON = SHOWING_ITEM
		elif (LISTING_ITEMS_ARRAY == WEAPONS):
			EQUIPPED_WEAPON = null
	if (SHOWING_ITEM_TYPE == ITEM_TYPE.ARMOR):
		if (USE_BUTTON_STATE == USE_BUTTON_STATES.EQUIP):
			EQUIPPED_ARMOR = SHOWING_ITEM
		elif (LISTING_ITEMS_ARRAY == ARMORS):
			EQUIPPED_ARMOR = null
	refresh_equipment()
	change_equip_button_label()
func handle_use_item_button_click():
	#todo use item functionality
	print("click use")
func handle_sell_item_button_click():
	show_confirmation_panel(CONFIRM_ACTION_TYPE.SELL)
func show_confirmation_panel(Action : CONFIRM_ACTION_TYPE):
	CONFIRM_PANEL.visible = true;
	ITEM_ACTION_BUTTONS.visible = false;
	CONFIRM_ACTION = Action
#endregion
#region calculations
func calculate_weight():
	WEIGHT = 0;
	for item in WEAPONS:
		WEIGHT = WEIGHT + item.itemWeight
	for item in ARMORS:
		WEIGHT = WEIGHT + item.itemWeight
	for item in UTILS:
		WEIGHT = WEIGHT + item.itemWeight
	WEIGHT_LABEL.text = "%s/%s kg" % [WEIGHT, MAX_WEIGHT]
	pass
func calculate_gold():
	GOLD = 0;
	#todo gold adding when selling and when collecting
	GOLD_LABEL.text = "%s g" % GOLD 
	pass
#endregion
