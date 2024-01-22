class_name InventoryItem extends Button

var nameItem : String;
var inventoryIndex : int;
var clicked : bool

func _init(itemName : String, index : int):
	nameItem = itemName
	inventoryIndex = index

func _ready():
	text = nameItem
	button_down.connect(func(): clicked = true)
	button_up.connect(func(): clicked = false)
