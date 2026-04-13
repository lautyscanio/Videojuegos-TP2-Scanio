extends Node

@export var vida_maxima: int = 20
var vida_actual: int
var jugador: CharacterBody2D

func _ready():
	jugador = get_parent()
	vida_actual = vida_maxima
	
	if %BarraSalud:
		%BarraSalud.max_value = vida_maxima
		%BarraSalud.value = vida_actual

func recibir_daño(cantidad: int):
	if vida_actual <= 0 or jugador.muerto: return
	
	vida_actual -= cantidad
	if %BarraSalud:
		%BarraSalud.value = vida_actual
		
	if vida_actual <= 0:
		vida_actual = 0
		_morir()
	else:
		_aplicar_stun(true)
		jugador.get_node("%AnimatedSprite2D").play("herido")
		await get_tree().create_timer(0.4).timeout
		if vida_actual > 0:
			_aplicar_stun(false)

func curar(cantidad: int):
	if vida_actual <= 0 or jugador.muerto: return
	
	vida_actual += cantidad
	if vida_actual > vida_maxima:
		vida_actual = vida_maxima
		
	if %BarraSalud:
		%BarraSalud.value = vida_actual

func _aplicar_stun(estado: bool):
	if jugador.has_node("Movimiento"):
		jugador.get_node("Movimiento").set_physics_process(!estado)
	if jugador.has_node("Golpe"):
		jugador.get_node("Golpe").set_process_input(!estado)
	if estado:
		jugador.velocity = Vector2.ZERO

func _morir():
	jugador.muerto = true 
	_aplicar_stun(true)
	jugador.set_physics_process(false)
	
	if jugador.is_in_group("jugador"):
		jugador.remove_from_group("jugador")
	
	jugador.get_node("%AnimatedSprite2D").play("muerte")
	if jugador.has_node("%pantalla_muerte"):
		jugador.get_node("%pantalla_muerte").show()
