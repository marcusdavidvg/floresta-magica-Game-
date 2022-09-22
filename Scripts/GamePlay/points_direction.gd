extends Node2D

func _ready():
	for pos in get_children():
		pos.add_to_group("points_position")
