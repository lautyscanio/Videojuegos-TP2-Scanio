extends CharacterBody2D
class_name JugadorPrincipal

var muerto: bool = false
var vida: int = 5
@onready var slots_enemigos = $%Slot_enemigo.get_children()

func reservar_slot(enemigo):
	var slots_disponibles = slots_enemigos.filter(func(slot): return slot.esta_libre())
	
	if slots_disponibles.size() == 0:
		return null
		
	slots_disponibles.sort_custom(func(a, b):
		var dist_a = enemigo.global_position.distance_to(a.global_position)
		var dist_b = enemigo.global_position.distance_to(b.global_position)
		return dist_a < dist_b
	)
	
	slots_disponibles[0].ocupar_slot(enemigo)
	return slots_disponibles[0]

func liberar_slot(enemigo):
	var slots_objetivo = slots_enemigos.filter(func(slot): return slot.ocupante == enemigo)
	if slots_objetivo.size() > 0:
		slots_objetivo[0].liberar_slot()


func recibir_daño(cantidad: int):
	if muerto: return
	vida -= cantidad
	print("Jugador recibió daño, vida: ", vida)
	if vida <= 0:
		muerto = true


func _on_hitbox_golpe_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
