extends Node2D
class_name SlotEnemigo

var ocupante = null

func esta_libre():
	return ocupante == null

func liberar_slot():
	ocupante = null

func ocupar_slot(enemigo):
	ocupante = enemigo
