class_name StatesAndHelpers extends Node

enum DIRECTIONS {
	UP_R,
	DOWN_R,
	UP_L,
	DOWN_L,
}

@onready
var ANIMATION_HELPER : AnimationHelper = $AnimationHelper
@onready
var ATTACK_STATE : AttackState = $AttackState
@onready
var PROJECTILE_HELPER : ProjectileHelper = $ProjectilesHelper
@onready
var DROP_HELPER : DropHelper = $DropHelper
