extends Control


func _on_Jogar_pressed():
	get_tree().change_scene("res://Scenes/Game_play/phases/phase_1.tscn")


func _on_tutorial_pressed():
	get_tree().change_scene('res://Scenes/game_interface/Tutorial.tscn')
	
func _input(event):
	
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()


func _on_credits_pressed():
	get_tree().change_scene("res://Scenes/game_interface/Credits.tscn")
