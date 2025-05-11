extends Node3D

signal platform_win

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		emit_signal("platform_win") # Сигнал о победе
