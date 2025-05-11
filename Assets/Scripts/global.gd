extends Node

# Переменная для хранения пути к текущему скину
var current_skin_path: String = "res://Assets/Characters/Bear/player_bear.tscn"
var current_layer = 10

# Функция для установки пути к скину
func set_skin_path(new_path: String) -> void:
	current_skin_path = new_path

# Функция для получения пути к скину
func get_skin_path() -> String:
	return current_skin_path

func get_current_layer() -> int:
	return current_layer
	
func set_layer(new_layer: int) -> void:
	current_layer = new_layer
