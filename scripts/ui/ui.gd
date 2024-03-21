class_name Ui extends Node2D

@onready
var JOYSTICK : Joystick = $CanvasLayer/HBoxContainer/joystick
@onready
var ATTACK_BUTTON : AttackButton = $CanvasLayer/HBoxContainer2/AttackButton
@onready
var DODGE_BUTTON : DodgeButton = $CanvasLayer/HBoxContainer2/DodgeButton
@onready
var INVENTORY : Inventory= $CanvasLayer/Inventory
@onready
var MENU_BUTTON : MenuActionButton = $CanvasLayer/HBoxContainer4/MenuButton
@onready
var ACTION_BUTTONS_CONTAINER : HBoxContainer = $CanvasLayer/HBoxContainer2
@onready
var INVENTORY_BUTTON : InventoryButton = $CanvasLayer/HBoxContainer4/InventoryButton
@onready
var OPTION_BUTTONS_CONTAINER : HBoxContainer = $CanvasLayer/HBoxContainer4
@onready
var FPS : Label = $CanvasLayer/Label

func _ready():
	INVENTORY.visible = false
	
func _process(_delta):
	if (INVENTORY_BUTTON.pressed):
		INVENTORY.visible = true
		INVENTORY.open_inventory_window()
	check_inventory_open()
	FPS.text = "FPS: "  + String.num(Engine.get_frames_per_second(), 0)
	
func check_inventory_open():
	if (INVENTORY.visible):
		INVENTORY_BUTTON.pressed = false
		hide_joystick()
		hide_action_buttons()
		hide_options_button()
	else:
		show_joystick()
		show_action_buttons()
		show_options_button()
		
func hide_joystick():
	JOYSTICK.visible = false
	
func hide_action_buttons():
	ACTION_BUTTONS_CONTAINER.visible = false
	
func hide_options_button():
	OPTION_BUTTONS_CONTAINER.visible = false
	
func show_joystick():
	JOYSTICK.visible = true
	
func show_action_buttons():
	ACTION_BUTTONS_CONTAINER.visible = true
	
func show_options_button():
	OPTION_BUTTONS_CONTAINER.visible = true 
