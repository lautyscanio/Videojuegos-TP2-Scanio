extends Area2D

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		if body.has_method("curar"):
			body.curar(1)
			queue_free()
