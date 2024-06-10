class_name Draugr extends BasicEnemyParentResource

var weaponsArray : Array[Weapon] = [Axe.new(), Sword.new(), Bow.new()]
var hp : int = 10
var speed : int = 500

func _init():
	super(weaponsArray, hp, speed);
