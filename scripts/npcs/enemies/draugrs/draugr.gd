class_name Draugr extends BasicEnemyParentResource

var weaponsArray : Array[Weapon] = [Axe.new(), Sword.new(), Bow.new()]

func _init():
	super(weaponsArray, 10, 500);
