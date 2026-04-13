extends Node

var disparando: bool = false
var jugador: CharacterBody2D
var _puede_disparar: bool = true
var _apuntando: Vector2 = Vector2.RIGHT

func _ready():
	jugador = get_parent()

func _process(_delta):
	var movimiento = get_parent().get_node("Movimiento")
	if movimiento and movimiento._direction != 0:
		_apuntando = Vector2.RIGHT * sign(movimiento._direction)

func _input(event):
	if not _puede_disparar:
		return

	if event.is_action_pressed("disparar"):
		_disparar()
		$Cooldown.start(0.5)

func _disparar():
	_puede_disparar = false
	disparando = true
	%AnimatedSprite2D.play("disparar")

	if not %AnimatedSprite2D.animation_finished.is_connected(_en_animacion_terminada):
		%AnimatedSprite2D.animation_finished.connect(_en_animacion_terminada)
	
	await get_tree().create_timer(0.5).timeout
	const bala = preload("res://Scenes/bala.tscn")
	var nueva_bala: RigidBody2D = bala.instantiate()

	nueva_bala.direccion = _apuntando
	nueva_bala.z_index = 10
	get_tree().current_scene.add_child(nueva_bala)
	# Uso la posicion del sprite para que la bala salga de donde se ve el personaje
	var sprite_pos:Vector2 = %AnimatedSprite2D.global_position
	nueva_bala.global_position = sprite_pos + _apuntando * 50 + Vector2(30, 25)	
	if _apuntando.x < 0:
		nueva_bala.get_node("Sprite2D").flip_h = true
func _en_animacion_terminada():
	disparando = false
	%AnimatedSprite2D.animation_finished.disconnect(_en_animacion_terminada)

func _en_espera_terminada():
	_puede_disparar = true
