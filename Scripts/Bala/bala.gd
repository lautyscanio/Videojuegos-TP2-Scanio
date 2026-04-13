extends RigidBody2D

@export var velocidad: float = 600.0
var direccion: Vector2 = Vector2.RIGHT

func _ready():
	gravity_scale = 0
	linear_velocity = direccion * velocidad
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		return
		
	if body.is_in_group("enemigo") and body.has_method("recibir_daño"):
		body.recibir_daño(1)
		
	queue_free()
