class_name BasicEnemyParentResource extends Resource

var weapon : Weapon;
var health : int;
var walkingSpeed : int;
var healthDropStrength : int;
var coinDropAmmount : int;
var coinDropStrength : int;

func _init(
	npc_weapons : Array[Weapon],
	npc_health : int,
	npc_walking_speed : int,
	npc_health_drop_strength : int,
	npc_coin_drop_ammount : int,
	npc_coin_drop_strength : int
):
	weapon = randomPickWeapon(npc_weapons);
	health = npc_health;
	walkingSpeed = npc_walking_speed;
	healthDropStrength = npc_health_drop_strength
	coinDropAmmount = npc_coin_drop_ammount
	coinDropStrength = npc_coin_drop_strength

func randomPickWeapon(npc_weapons : Array[Weapon]):
	var randomizer: RandomNumberGenerator = RandomNumberGenerator.new()
	randomizer.randomize()
	var weaponIndex : int = randomizer.randi_range(0, npc_weapons.size() -1)
	return npc_weapons[weaponIndex]
