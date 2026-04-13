extends RigidBody2D

var velocidad: float = 600.0
var direccion: Vector2 = Vector2.RIGHT

func _ready():
	gravity_scale = 0
	linear_velocity = direccion * velocidad
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_en_cuerpo_tocado)
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _en_cuerpo_tocado(cuerpo):
	if cuerpo.is_in_group("enemigo"):
		cuerpo.recibir_daño(1)
	queue_free()
