extends Area2D

func _ready():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("idle")

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		get_tree().change_scene_to_file("res://Scenes/escena_final.tscn")
