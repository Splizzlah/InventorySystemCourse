extends KinematicBody2D

export (int) var speed = 200

var _velocity := Vector2()


func _physics_process(delta : float) -> void:
	_get_input()
	_velocity = move_and_slide(_velocity)

	
func _get_input() -> void:
	_velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		_velocity.x += 1
	if Input.is_action_pressed("move_left"):
		_velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		_velocity.y += 1
	if Input.is_action_pressed("move_up"):
		_velocity.y -= 1
	_velocity = _velocity.normalized() * speed
