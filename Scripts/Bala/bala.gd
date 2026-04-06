extends RigidBody2D

var velocidad:float = 600.0
var direccion:Vector2 = Vector2.RIGHT

func _ready():
	gravity_scale = 0
	linear_velocity = direccion * velocidad
	await get_tree().create_timer(3.0).timeout
	queue_free()
