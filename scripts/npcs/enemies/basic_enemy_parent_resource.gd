class_name BasicEnemyParentResource extends Resource

var weapon : Weapon;
var health : int;
var walkingSpeed : int;

func _init(
	npc_weapons : Array[Weapon],
	npc_health : int,
	npc_walking_speed : int
):
	weapon = randomPickWeapon(npc_weapons);
	health = npc_health;
	walkingSpeed = npc_walking_speed;

func randomPickWeapon(npc_weapons : Array[Weapon]):
	var randomizer: RandomNumberGenerator = RandomNumberGenerator.new()
	randomizer.randomize()
	var weaponIndex : int = randomizer.randi_range(0, npc_weapons.size() -1)
	return npc_weapons[weaponIndex]
