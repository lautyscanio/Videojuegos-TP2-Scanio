extends Control

func _ready():
	if Global.nivel_desbloqueado < 2:
		%nivel2.disabled = true
	else:
		%nivel2.disabled = false
		%nivel2.icon = preload("res://Assets/Fondos/fondo_3.png") 

	if Global.nivel_desbloqueado < 3:
		%nivel3.disabled = true
	else:
		%nivel3.disabled = false
		%nivel3.icon = preload("res://Assets/Fondos/fondo_2.png") 


func _on_nivel_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/villa.tscn")


func _on_nivel_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/nivel_2.tscn")


func _on_nivel_3_pressed():
	get_tree().change_scene_to_file("res://Scenes/nivel_3.tscn")
