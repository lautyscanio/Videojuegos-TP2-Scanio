
extends Node2D

@onready var pared_medio = $pared_medio
@onready var pared_enemigo = $pared_enemigo

var oleada_avanzada = false
var nivel_terminado = false

func _process(_delta):
	if nivel_terminado:
		return
		
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	var cantidad_vivos = 0
	
	for enemigo in enemigos:
		if not enemigo.muerto: 
			cantidad_vivos += 1 
			
	if cantidad_vivos <= 4 and not oleada_avanzada:
		_avanzar_oleada()
		
	if cantidad_vivos == 0:
		_ganar_nivel()

func _avanzar_oleada():
	oleada_avanzada = true
	
	if is_instance_valid(pared_medio):
		pared_medio.queue_free()
		
	if is_instance_valid(pared_enemigo):
		pared_enemigo.queue_free()
		
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador and jugador.has_node("Camera2D"):
		jugador.get_node("Camera2D").limit_right = 4105 
		
func _ganar_nivel():	
	nivel_terminado = true
	Global.nivel_desbloqueado = 2 
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Scenes/seleccion_niveles.tscn")
