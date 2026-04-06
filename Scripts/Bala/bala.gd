extends RigidBody2D
var velocidad = 600
func _ready():
	linear_velocity=Vector2.RIGHT.rotated(rotation) * velocidad
	await get_tree().create_timer(3.0).timeout
	queue_free()
