extends TerrestrialEnemy

func _ready():
	sprite = get_node("Sprites")
	distance_attack = 90
	is_fly = true
	is_water_enemy = false
	navigation = get_parent().get_node("Map_phase_1/Tiles/navigation_surface")


func _on_Sprites_animation_finished():
	damage_to_player()
	reset_sprite()


func _on_get_path_timeout():
	if get_distance_player() < distance_detect and get_distance_player() > distance_attack:
		get_path_to_player()


func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	is_visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	is_visible = false
