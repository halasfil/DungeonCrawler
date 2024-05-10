extends Node

@onready
var NAVIGATION_REGION : NavigationRegion2D = $NavigationRegion2D

# Called when the node enters the scene tree for the first time.
func _ready():
	NAVIGATION_REGION.bake_navigation_polygon()
