extends Node

var jugador: CharacterBody2D
var atacando: bool = false
var puede_atacar: bool = true

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

	var col_golpe = %hitbox_golpe.get_node("CollisionShape2D")
	var lado = -1 if %AnimatedSprite2D.flip_h else 1
	col_golpe.position.x = abs(col_golpe.position.x) * lado
	col_golpe.disabled = false

	if not %AnimatedSprite2D.animation_finished.is_connected(_en_animacion_terminada):
		%AnimatedSprite2D.animation_finished.connect(_en_animacion_terminada)

func _en_animacion_terminada():
	%hitbox_golpe.get_node("CollisionShape2D").disabled = true
	atacando = false
	%AnimatedSprite2D.animation_finished.disconnect(_en_animacion_terminada)

func _en_espera_terminada():
	puede_atacar = true
	
func _on_hitbox_golpe_body_entered(body):
	if body.is_in_group("enemigo"):
		body.recibir_daño(1)
