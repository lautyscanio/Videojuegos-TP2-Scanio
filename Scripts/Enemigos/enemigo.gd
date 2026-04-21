extends CharacterBody2D
@export var escena_item: PackedScene
@export var vida: float = 3
@export var velocidad: float = 180.0
@export var daño_ataque: float = 1
@export var distancia_ataque: float = 120.0
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

		if abs(distancia) > 5 and dist_al_jugador > distancia_ataque:
			velocity.x = direccion * velocidad
			%AnimatedSprite2D.play("walk")
			%AnimatedSprite2D.flip_h = direccion < 0
			move_and_slide()
			for i in get_slide_collision_count():
				var choque = get_slide_collision(i)
				if choque.get_collider() and choque.get_collider().is_in_group("jugador"):
					velocity.x = 0
					if puede_atacar:
						_atacar()
					break
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
		if jugador != null:
			%AnimatedSprite2D.flip_h = (jugador.global_position.x - global_position.x) < 0

func _atacar():
	atacando = true
	puede_atacar = false
	%AnimatedSprite2D.play(ataques[indice_combo])
	indice_combo = (indice_combo + 1) % ataques.size()
		
	
	if has_node("%hitbox_enemigo/CollisionShape2D"):
		var col_golpe = %hitbox_enemigo.get_node("CollisionShape2D")
		var lado = -1 if %AnimatedSprite2D.flip_h else 1
		col_golpe.position.x = abs(col_golpe.position.x) * lado
		col_golpe.disabled = false

func _en_animacion_terminada():
	if muerto:
		return
	if atacando:
		if has_node("%hitbox_enemigo/CollisionShape2D"):
			%hitbox_enemigo.get_node("CollisionShape2D").disabled = true
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
		velocity = Vector2.ZERO
		
		var item = escena_item.instantiate()
		item.global_position = global_position
		item.global_position.y += 20 
		get_tree().current_scene.call_deferred("add_child", item)
		
		if mi_slot != null and jugador != null:
			jugador.liberar_slot(self)
			
		%AnimatedSprite2D.play("muerte")
		$CollisionShape2D.set_deferred("disabled", true)
		
		if has_node("%hitbox_enemigo/CollisionShape2D"):
			get_node("%hitbox_enemigo/CollisionShape2D").set_deferred("disabled", true)
			
		await get_tree().create_timer(1.5).timeout
		queue_free()
	else:
		indice_combo = 0
		esta_herido = true
		velocity = Vector2.ZERO
		%AnimatedSprite2D.play("herido")
		
		await get_tree().create_timer(0.3).timeout
		
		esta_herido = false
		puede_atacar = true

func _on_hitbox_enemigo_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		if body.has_method("recibir_daño"):
			body.recibir_daño(daño_ataque)
