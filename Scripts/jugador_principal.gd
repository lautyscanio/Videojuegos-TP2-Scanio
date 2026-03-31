extends CharacterBody2D

var velocidad = 300.0

func _physics_process(delta):
	var direccion_x = Input.get_axis("ui_left", "ui_right")
	var direccion_y = Input.get_axis("ui_up", "ui_down")
	
	velocity.x = direccion_x * velocidad
	velocity.y = direccion_y * velocidad
	
	if direccion_x != 0:
		$Sprite2D.flip_h = direccion_x < 0
		
	move_and_slide()
	

	global_position.y = clamp(global_position.y, 400, 600)
