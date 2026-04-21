extends "res://Scripts/Enemigos/enemigo.gd"

const bala_boss = preload("res://Scenes/bala_enemigo.tscn")
const item_curacion = preload("res://Scenes/curacion_fernet.tscn")

@export var distancia_disparo: float = 600.0
var danio_acumulado = 0.0
var puede_disparar = true 

@onready var barra_vida = $barra_vida

func _ready():
	super._ready()
	ataques = ["pegar_1"]
	%AnimatedSprite2D.sprite_frames.set_animation_loop("pegar_1", false)
	%AnimatedSprite2D.sprite_frames.set_animation_loop("disparo_1", false)
	barra_vida.max_value = vida
	barra_vida.value = vida

func _physics_process(delta):
	if muerto or jugador == null:
		return
	
	barra_vida.scale.x = abs(barra_vida.scale.x) * (1.0)
	
	if esta_herido:
		velocity.x = move_toward(velocity.x, 0, 12)
		move_and_slide()
		return

	var dist_al_jugador = abs(global_position.x - jugador.global_position.x)
	var direccion_x = sign(jugador.global_position.x - global_position.x)
	
	if not atacando:
		if dist_al_jugador > distancia_ataque:
			if dist_al_jugador <= distancia_disparo:
				velocity.x = direccion_x * (velocidad * 0.5)
			else:
				velocity.x = direccion_x * velocidad
			%AnimatedSprite2D.play("walk")
			%AnimatedSprite2D.flip_h = direccion_x < 0
		else:
			velocity.x = 0
			%AnimatedSprite2D.flip_h = direccion_x < 0
			
		move_and_slide()
		
		var choca_jugador = false
		for i in get_slide_collision_count():
			var choque = get_slide_collision(i)
			if choque.get_collider() and choque.get_collider().is_in_group("jugador"):
				choca_jugador = true
				break

		if dist_al_jugador <= distancia_ataque or choca_jugador:
			velocity.x = 0
			if puede_atacar:
				_atacar()
			else:
				%AnimatedSprite2D.play("idle")
		elif dist_al_jugador <= distancia_disparo:
			velocity.x = 0
			if puede_disparar:
				_atacar_distancia()

func recibir_daño(cantidad):
	if muerto: return
	
	vida -= cantidad
	barra_vida.value = vida
	danio_acumulado += cantidad
	
	if danio_acumulado >= 5.0:
		_soltar_curacion()
		danio_acumulado = 0.0
		
	if vida <= 0:
		muerto = true 
		atacando = false
		esta_herido = false
		velocity = Vector2.ZERO
		barra_vida.hide()
		
		if mi_slot != null and jugador != null:
			jugador.liberar_slot(self)
			
		%AnimatedSprite2D.play("muerte")
		$CollisionShape2D.set_deferred("disabled", true)
		if has_node("%hitbox_enemigo/CollisionShape2D"):
			get_node("%hitbox_enemigo/CollisionShape2D").set_deferred("disabled", true)
			
		await get_tree().create_timer(2.0).timeout
		
		if escena_item != null:
			var item = escena_item.instantiate()
			var lado_contrario = 1 if %AnimatedSprite2D.flip_h else -1
			item.global_position = global_position + Vector2(lado_contrario * 100, 20)
			get_tree().current_scene.add_child(item)
			
		await get_tree().create_timer(1.0).timeout
		queue_free()
	else:
		var tiempo_stun = 0.15
		if cantidad >= 1.0:
			tiempo_stun = 0.6
			
		if not esta_herido:
			esta_herido = true
			atacando = false 
			var direccion_empuje = sign(global_position.x - jugador.global_position.x)
			if direccion_empuje == 0: direccion_empuje = -1
			
			velocity.x = direccion_empuje * 200 
			%AnimatedSprite2D.play("herido")
			
			await get_tree().create_timer(tiempo_stun).timeout
			esta_herido = false
			puede_atacar = true
		

func _soltar_curacion():
	var drop = item_curacion.instantiate()
	var lado = -1 if %AnimatedSprite2D.flip_h else 1
	drop.global_position = global_position + Vector2(lado * 50, 0)
	
	get_tree().current_scene.call_deferred("add_child", drop)

func _atacar_distancia():
	atacando = true 
	puede_disparar = false 
	%AnimatedSprite2D.play("disparo_1") 
	
	await get_tree().create_timer(0.3).timeout
	
	if muerto or not is_inside_tree():
		return
	
	var bala = bala_boss.instantiate()
	var offset_x = 80.0 if not %AnimatedSprite2D.flip_h else -80.0
	bala.global_position = global_position + Vector2(offset_x, -40)
	bala.direccion = Vector2.LEFT if %AnimatedSprite2D.flip_h else Vector2.RIGHT
	get_tree().current_scene.add_child(bala)
	
	atacando = false 
	
	await get_tree().create_timer(4.0).timeout
	if not muerto and is_inside_tree():
		puede_disparar = true

func _en_animacion_terminada():
	if %AnimatedSprite2D.animation == "pegar_1":
		super._en_animacion_terminada()
