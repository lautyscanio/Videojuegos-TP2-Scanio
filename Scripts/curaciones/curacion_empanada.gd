extends Area2D


func _ready():

	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is JugadorPrincipal: 
		
		if body.has_node("Salud"):
			var salud_node = body.get_node("Salud")

			var cantidad_cura = salud_node.vida_maxima / 2
			body.curar(cantidad_cura)
			
		
			queue_free()
