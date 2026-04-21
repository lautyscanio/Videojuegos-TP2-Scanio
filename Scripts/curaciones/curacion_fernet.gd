extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		if body.has_method("curar"):
			
			body.curar(2)
			queue_free()
