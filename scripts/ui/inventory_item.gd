class_name InventoryItem extends Button

var nameItem : String;
var inventoryIndex : int;
var clicked : bool
var type : Inventory.ITEM_TYPE

func _init(itemName : String = "", index : int = 0, itemType : Inventory.ITEM_TYPE = Inventory.ITEM_TYPE.WEAPON):
	nameItem = itemName
	inventoryIndex = index
	type = itemType

func _ready():
	text = nameItem
	button_down.connect(func(): clicked = true)
	button_up.connect(func(): clicked = false)
