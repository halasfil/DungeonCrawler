class_name Ui extends Node2D

@onready
var JOYSTICK : Joystick = $CanvasLayer/HBoxContainer/joystick

@onready
var ATTACK_BUTTON = $CanvasLayer/HBoxContainer2/AttackButton

@onready
var DODGE_BUTTON = $CanvasLayer/HBoxContainer2/DodgeButton

@onready
var INVENTORY = $CanvasLayer/Inventory

@onready
var MENU_BUTTON = $CanvasLayer/HBoxContainer4/MenuButton

@onready
var ACTION_BUTTONS_CONTAINER = $CanvasLayer/HBoxContainer2

@onready
var INVENTORY_BUTTON : InventoryButton = $CanvasLayer/HBoxContainer4/InventoryButton

func _ready():
	INVENTORY.visible = false
	
func _process(_delta):
	if (INVENTORY_BUTTON.pressed):
		INVENTORY.visible = true
	if (INVENTORY.visible):
		INVENTORY_BUTTON.pressed = false
		INVENTORY_BUTTON.visible = false
		MENU_BUTTON.visible = false
		JOYSTICK.visible = false
		ACTION_BUTTONS_CONTAINER.visible = false
	else:
		MENU_BUTTON.visible = true
		JOYSTICK.visible = true
		ACTION_BUTTONS_CONTAINER.visible = true
		INVENTORY_BUTTON.visible = true
