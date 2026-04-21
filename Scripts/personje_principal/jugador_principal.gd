extends CharacterBody2D
class_name JugadorPrincipal

var muerto = false
@onready var slots_enemigos = $%Slot_enemigo.get_children()
@export var daño_ataque: float = 1

func _ready():
	muerto = false
	if has_node("%pantalla_muerte"):
		%pantalla_muerte.hide()
	if not is_in_group("jugador"):
		add_to_group("jugador")
	%AnimatedSprite2D.play("idle")

func recibir_daño(cantidad: int):
	if has_node("Salud"):
		$Salud.recibir_daño(cantidad)

func curar(cantidad: int):
	if has_node("Salud"):
		$Salud.curar(cantidad)

func reservar_slot(enemigo):
	for slot in slots_enemigos:
		if slot.esta_libre():
			slot.ocupar_slot(enemigo)
			return slot
	return null

func liberar_slot(enemigo):
	for slot in slots_enemigos:
		if slot.ocupante == enemigo:
			slot.liberar_slot()


func _on_hitbox_enemigo_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		
		if body.has_method("recibir_daño"):
			body.recibir_daño(daño_ataque)
