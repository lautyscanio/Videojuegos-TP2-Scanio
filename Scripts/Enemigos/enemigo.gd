extends CharacterBody2D

@export var vida: int = 3
@export var velocidad: float = 180.0
var esta_herido = false

var jugador
var mi_slot = null
var muerto = false
var ataques = ["pegar_1", "pegar_2", "pegar_3"]
var indice_combo = 0
var atacando = false
var puede_atacar = true

func _ready():
	jugador = get_tree().get_first_node_in_group("jugador")
	%AnimatedSprite2D.animation_finished.connect(_en_animacion_terminada)
	add_to_group("enemigo")

func _physics_process(delta):
	if muerto or atacando or esta_herido or jugador == null:
		return

	if mi_slot == null:
		mi_slot = jugador.reservar_slot(self)

	if mi_slot != null:
		var distancia = mi_slot.global_position.x - global_position.x
		var direccion = sign(distancia)
		var dist_al_jugador = abs(global_position.x - jugador.global_position.x)

		if abs(distancia) > 5 and dist_al_jugador > 120:
			velocity.x = direccion * velocidad
			%AnimatedSprite2D.play("walk")
			%AnimatedSprite2D.flip_h = direccion < 0
			move_and_slide()
		else:
			velocity.x = 0
			%AnimatedSprite2D.flip_h = (jugador.global_position.x - global_position.x) < 0
			
			if puede_atacar:
				_atacar()
			else:
				%AnimatedSprite2D.play("idle")
	else:
		velocity.x = 0
		%AnimatedSprite2D.play("idle")
		%AnimatedSprite2D.flip_h = (jugador.global_position.x - global_position.x) < 0

func _atacar():
	atacando = true
	puede_atacar = false
	%AnimatedSprite2D.play(ataques[indice_combo])
	indice_combo = (indice_combo + 1) % ataques.size()
	# Hacer daño al jugador en el momento del golpe
	await get_tree().create_timer(0.25).timeout
	if not muerto and jugador != null:
		var distancia = global_position.distance_to(jugador.global_position)
		if distancia < 200 and jugador.has_method("recibir_daño"):
			jugador.recibir_daño(1)

func _en_animacion_terminada():
	if muerto:
		return
	if atacando:
		atacando = false
		await get_tree().create_timer(0.5).timeout
		puede_atacar = true

func recibir_daño(cantidad):
	if muerto: return
	vida -= cantidad
	
	if vida <= 0:
		muerto = true
		atacando = false
		esta_herido = false
		if mi_slot != null:
			jugador.liberar_slot(self)
		%AnimatedSprite2D.play("muerte")
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(1.5).timeout
		queue_free()
	else:
		indice_combo = 0
		esta_herido = true
		velocity.x = 0
		%AnimatedSprite2D.play("herido")
		await get_tree().create_timer(0.3).timeout
		esta_herido = false
		puede_atacar = true
