extends Control

func _ready():
	if Global.nivel_desbloqueado < 2:
		%nivel2.disabled = true
	else:
		%nivel2.disabled = false
		%nivel2.icon = null 
		var sprite_n2 = %nivel2.get_node("Sprite2D")
		sprite_n2.texture = preload("res://Assets/Fondos/fondo4.png") 
		sprite_n2.show() 

	if Global.nivel_desbloqueado < 3:
		%nivel3.disabled = true
	else:
		%nivel3.disabled = false
		%nivel3.icon = null 
		var sprite_n3 = %nivel3.get_node("Sprite2D")
		sprite_n3.texture = preload("res://Assets/Fondos/fondo_2.png")
		sprite_n3.show() 


func _on_nivel_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/nivel_1.tscn")


func _on_nivel_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/nivel_3.tscn")


func _on_nivel_3_pressed():
	get_tree().change_scene_to_file("res://Scenes/nivel_2.tscn")
