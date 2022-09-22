extends Node2D

func _on_right_screen_exited():
	get_node("Plataforms_right").visible = false


func _on_right_screen_entered():
	get_node("Plataforms_right").visible = true


func _on_left_screen_entered():
	get_node("Plataforms_left").visible = true


func _on_left_screen_exited():
	get_node("Plataforms_left").visible = false

