extends CharacterBody2D

var velocidad = 200.0

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	var direccion_x = Input.get_axis("ui_left", "ui_right")
	var direccion_y = Input.get_axis("ui_up", "ui_down")
	
	velocity.x = direccion_x * velocidad
	velocity.y = direccion_y * velocidad
	
	# Flip del sprite según la dirección
	if direccion_x != 0:
		$AnimatedSprite2D.flip_h = direccion_x < 0
	
	# Cambiar animación según si se mueve o está quieto
	if direccion_x != 0 or direccion_y != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()
