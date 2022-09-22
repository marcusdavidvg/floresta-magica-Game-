extends Control



func _on_discord_pressed():
	OS.shell_open('https://discord.gg/X3XeTzn3Gn')


func _on_voltar_pressed():
	get_tree().change_scene("res://Scenes/game_interface/Menu.tscn")
