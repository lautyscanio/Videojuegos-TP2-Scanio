extends Node

const MIN_SPEED: float = 10
const MAX_SPEED: float = 350.0
const JUMP_VELOCITY = -950.0

var jugador: CharacterBody2D

var _direction: float = 0
var _last_direction: float = 0
var _speed: float = 0
var _gravity: float = 20
var _jumping: bool = false

func _ready():
	jugador = get_parent()
	%AnimatedSprite2D.play("idle")

func _input(event: InputEvent):
	if event.is_action("ui_left") or event.is_action("ui_right"):
		_direction = Input.get_axis("ui_left", "ui_right")
		_last_direction = _direction

	var golpe = get_parent().get_node("Golpe")
	if event.is_action_pressed("ui_up") and jugador.is_on_floor() and not (golpe and golpe.atacando):
		_jump()

func _physics_process(delta):
	if not jugador.is_on_floor():
		jugador.velocity.y += _gravity
		var golpe = get_parent().get_node("Golpe")
		if not (golpe and golpe.atacando):
			%AnimatedSprite2D.play("saltar")

	_movement(delta)
	jugador.move_and_slide()
func _movement(delta):
	var golpe = get_parent().get_node("Golpe")
	var disparo = get_parent().get_node("Disparo")
	if (golpe and golpe.atacando) or (disparo and disparo.disparando):
		_speed = move_toward(_speed, 0, delta * 2000)
		jugador.velocity.x = _speed
		return

	if not jugador.is_on_floor():
		if _direction != 0:
			_speed = move_toward(_speed, _direction * MAX_SPEED, delta * 300)
			jugador.velocity.x = _speed
			%AnimatedSprite2D.flip_h = _direction < 0
		return

	if _direction == 0:
		_speed = move_toward(_speed, 0, delta * 2000)
		if absf(_speed) <= MIN_SPEED:
			_speed = 0
		jugador.velocity.x = _speed
		%AnimatedSprite2D.play("idle")
		return

	if absf(_speed) <= MAX_SPEED or \
		(absf(_speed) > MAX_SPEED and sign(_speed) != _direction):
		_speed = move_toward(_speed, _direction * MAX_SPEED, delta * 2000)

	jugador.velocity.x = _speed
	%AnimatedSprite2D.flip_h = _direction < 0
	%AnimatedSprite2D.play("walk")

func _jump():
	_jumping = true
	jugador.velocity.y += JUMP_VELOCITY
	%AnimatedSprite2D.play("saltar")
