extends Node

var jugador: CharacterBody2D
var atacando: bool = false
var puede_atacar: bool = true

func _ready():
	jugador = get_parent()
	$Cooldown.timeout.connect(_en_espera_terminada)

func _input(event):
	if not puede_atacar or atacando:
		return

	if event.is_action_pressed("pegar"):
		_iniciar_ataque("pegar")
		$Cooldown.start(0.5)

func _iniciar_ataque(nombre_animacion: String):
	atacando = true
	puede_atacar = false
	%AnimatedSprite2D.play(nombre_animacion)
	%hitbox_golpe.get_node("CollisionShape2D").disabled = false

	if not %AnimatedSprite2D.animation_finished.is_connected(_en_animacion_terminada):
		%AnimatedSprite2D.animation_finished.connect(_en_animacion_terminada)

func _en_animacion_terminada():
	%hitbox_golpe.get_node("CollisionShape2D").disabled = true
	atacando = false
	%AnimatedSprite2D.animation_finished.disconnect(_en_animacion_terminada)

func _en_espera_terminada():
	puede_atacar = true
