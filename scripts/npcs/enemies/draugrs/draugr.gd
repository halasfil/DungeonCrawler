class_name Draugr extends BasicEnemyParentResource

var weaponsArray : Array[Weapon] = [Bow.new()]
var hp : int = 10
var speed : int = 500
var healthStr : int = 5
var coinAmmount : int = 3
var coinStrength : int = 1

func _init():
	super(weaponsArray, hp, speed, healthStr, coinAmmount, coinStrength);
