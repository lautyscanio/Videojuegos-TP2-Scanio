extends Control

func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://Scenes/seleccion_niveles.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
