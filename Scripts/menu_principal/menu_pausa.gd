extends Node


func _on_texture_button_pressed() -> void:
	var esta_pausado = get_tree().paused
	
	get_tree().paused = not get_tree().paused
