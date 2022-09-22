extends Node2D

var enemys: Array = [
	preload("res://Scenes/Enemys/fish_pink.tscn"),
	preload("res://Scenes/Enemys/fish_blue.tscn")
]

export(int) var limit_fish
var amount_fish: int

func _ready():
	randomize()
	amount_fish = 0
	summon_enemys()

func summon_enemys() -> void:
	for i in limit_fish - amount_fish:
		var fish = enemys[rand_range(0, 2)].instance()
		var position: Vector2 = Vector2(rand_range(-6000, 7900), rand_range(1400, 2000))
		
		add_child(fish)
		fish.position = position
		amount_fish += 1

func _on_summon_timeout():
	summon_enemys()
