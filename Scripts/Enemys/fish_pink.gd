extends TerrestrialEnemy

func _ready():
	sprite = get_node("Sprites")
	distance_attack = 90
	is_fly = false
	is_water_enemy = true
	speed += 50
	navigation = get_parent().get_parent().get_node("Map_phase_1/Tiles/navigation_water")

func _on_Sprites_animation_finished():
	damage_to_player()
	reset_sprite()


func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
