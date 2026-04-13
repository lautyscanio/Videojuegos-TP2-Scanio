extends Node

var jugador: CharacterBody2D
var atacando: bool = false
var puede_atacar: bool = true
var rango_golpe: float = 300.0

func _ready():
	jugador = get_parent()
	if not $Cooldown.timeout.is_connected(_en_espera_terminada):
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

	var lado = -1 if %AnimatedSprite2D.flip_h else 1
	_aplicar_daño(lado)

	if not %AnimatedSprite2D.animation_finished.is_connected(_en_animacion_terminada):
		%AnimatedSprite2D.animation_finished.connect(_en_animacion_terminada)

func _aplicar_daño(lado: int):
	var origen = %AnimatedSprite2D.global_position
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	for enemigo in enemigos:
		var distancia_x = enemigo.global_position.x - origen.x
		var distancia_y = abs(enemigo.global_position.y - origen.y)
		if distancia_y > 300:
			continue
		if lado == 1 and distancia_x > -50 and distancia_x < rango_golpe:
			enemigo.recibir_daño(1)
		elif lado == -1 and distancia_x < 50 and distancia_x > -rango_golpe:
			enemigo.recibir_daño(1)

func _en_animacion_terminada():
	atacando = false
	%AnimatedSprite2D.animation_finished.disconnect(_en_animacion_terminada)

func _en_espera_terminada():
	puede_atacar = true
