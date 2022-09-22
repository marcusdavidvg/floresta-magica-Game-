extends Node2D

export(int) var limit_plants
var amount_plants: int = 0

var scece = preload("res://Scenes/Enemys/Plant.tscn")
var positions: Array = []

func _ready():
	randomize()
	generate_plants_on_the_map()

func generate_plants_on_the_map() -> void:
	
	while amount_plants <= limit_plants:
		var random_position: Vector2 = get_children()[rand_range(0, get_children().size())].global_position
		
		if not positions.has(random_position):
			var plant = scece.instance()
			add_child(plant)
			plant.global_position = random_position
			positions.append(random_position)
			amount_plants += 1
		
