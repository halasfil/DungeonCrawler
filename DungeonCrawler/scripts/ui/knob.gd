extends Sprite2D

@export
var maxLength : float = 120

@onready 
var joystickParent : Node2D = $".."
var pressing : bool = false;

func _ready() -> void:
	maxLength *= joystickParent.scale.x

func _process(delta) -> void:
	if (pressing):
		var angle : float = joystickParent.global_position.angle_to_point(get_global_mouse_position())
		joystickParent.angle = angle
		var touchFource : float = get_global_mouse_position().distance_to(joystickParent.global_position)
		if (touchFource <= maxLength):
			global_position = get_global_mouse_position()
		else:
			global_position.x = joystickParent.global_position.x + cos(angle) * maxLength
			global_position.y = joystickParent.global_position.y + sin(angle) * maxLength
		calculateVector()
	else:
		global_position = lerp(global_position, joystickParent.global_position, delta * 8)
		joystickParent.posVector = Vector2.ZERO

func calculateVector() -> void:
	joystickParent.posVector.x = (global_position.x - joystickParent.global_position.x)/maxLength
	joystickParent.posVector.y = (global_position.y - joystickParent.global_position.y)/maxLength
		
func _on_touch_screen_button_pressed() -> void:
	pressing = true

func _on_touch_screen_button_released() -> void:
	pressing = false
