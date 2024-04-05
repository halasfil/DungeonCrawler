extends Node

@onready
var PLAYER : Player = $"../Player"
@onready
var ANIMATION : AnimationPlayer = $AnimationPlayer
@onready
var TIMER : Timer = $Timer
enum STATES {
	MOVING,
	WAITING
}
var STATE : STATES = STATES.WAITING
var RAND_TRIES : int = 0;

func check_if_not_too_close(rand_position, target_position):
	if (abs(target_position.x) - abs(rand_position.x) < 5 || abs(target_position.y) - abs(rand_position.y) < 5):
		return true
	return false

func randomize_position(target_position) -> Vector2:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var rand_position : Vector2 = Vector2(target_position.x + random.randi_range(-25, 25),
	target_position.y + random.randi_range(-25, 25))
	if check_if_not_too_close(rand_position, target_position) && RAND_TRIES <= 2:
		RAND_TRIES += 1
		if (RAND_TRIES == 2):
			return self.position
		else:
			return randomize_position(target_position)
	else:
		RAND_TRIES = 0;
		return rand_position

func move():
	STATE = STATES.MOVING
	var target_position : Vector2 = PLAYER.position
	var random_position : Vector2 = randomize_position(target_position)
	var tween = create_tween()
	tween.tween_property(self, "global_position", random_position, 2)
	tween.tween_callback(
	func end_movement():
		self.global_position = random_position
		STATE = STATES.WAITING
	)
	TIMER.start()

func bounce():
	if (STATE != STATES.MOVING):
		ANIMATION.play("idle")
		
func _on_timer_timeout():
	move()
	
func _process(_delta):
	bounce()
