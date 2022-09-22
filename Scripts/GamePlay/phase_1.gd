extends Node2D

onready var node_player: KinematicBody2D = get_node("player")
onready var progress_bar: TextureProgress = get_node("ui/HearthIcon/ProgressBar")
onready var animation: AnimationPlayer = get_node("AnimationPlayer")
onready var message: Label = get_node("ui/message")
onready var progress_timer: TextureProgress = get_node("ui/show_time")
onready var spawms: Array = get_node("spawm_player").get_children()
onready var background_forest: Sprite = get_node("background")
onready var player: KinematicBody2D = get_node("player")

var list_air_enemys: Array = [
	preload("res://Scenes/Enemys/air_enemy_blue.tscn"),
	preload("res://Scenes/Enemys/air_enemy_pink.tscn")
	
]

var list_resources: Array = [
	preload('res://Scenes/Objects/resources/resource_blue.tscn'),
	preload("res://Scenes/Objects/resources/resource_green.tscn"),
	preload("res://Scenes/Objects/resources/resource_orange.tscn")
]

export(int) var timer_game
export(int) var necessary_amount
export(int) var amount_enemys
var current_second: int
var aim_cursor = load("res://Textures/ui/cursor.png")

func _ready():
	randomize()
	add_to_group("setings")
	update_info()
	message.visible = false
	current_second = timer_game
	change_progrees_timer()
	generate_enemys()
	drop_resources()
	Input.set_custom_mouse_cursor(aim_cursor, 0, Vector2(16, 16))
	player.global_position = spawms[rand_range(0, spawms.size())].global_position
	background_forest.global_position = player.global_position
	
	reset_level()
	
func reset_level() -> void:
	Data.resources_amount["blue"].amount = 0
	Data.resources_amount["green"].amount = 0
	Data.resources_amount["orange"].amount = 0
	
func update_info() -> void:
	var labels: Array = get_node("ui/amounts_info").get_children()
	
	for node in labels:
		if node as Label:
			node.text = str(Data.resources_amount[node.name].amount)
			node.get_node("min").text = str(Data.resources_amount[node.name].objective)
			
		if node as TextureRect:
			node.get_node('Label').text = str(Data.amount_arrows)
	
	progress_bar.max_value = node_player.max_hearth
	progress_bar.value = node_player.hearth

	if get_result():
		victory()

func get_result() -> bool:
	var result: bool = false
	
	if Data.resources_amount["orange"].amount >= Data.resources_amount["orange"].objective:
		if Data.resources_amount["blue"].amount >= Data.resources_amount["blue"].objective:
			if Data.resources_amount["green"].amount >= Data.resources_amount["green"].objective:
				result =  true
			
	return result

func move_background() -> void:
	if not player.is_on_water() and player.camera.current and player.position.y < 1020:
		background_forest.global_position = player.global_position
	
func victory() -> void:
	end_game("vitoria")
	
func defeat_game() -> void:
	end_game("derrota")
	
func end_game(text: String) -> void:
	message.visible = true
	message.text = text
	animation.play("show_message")
	

func change_progrees_timer() -> void:
	progress_timer.max_value = timer_game
	progress_timer.value = current_second
	
	if current_second < 1:
		defeat_game()
		
	print("timer ", current_second)
		
func drop_resources() -> void:
	
	for i in Data.resources_amount["green"].objective + 15:
		var position: Vector2 = Vector2(rand_range(-5700, 7700), rand_range(-2500,590))
		var resource = list_resources[rand_range(0, 3)].instance()
		add_child(resource)
		resource.global_position = position
	
	for i in Data.resources_amount["blue"].objective + 14:
		var position: Vector2 = Vector2(rand_range(-5700, 7700), rand_range(-2500,590))
		var resource = list_resources[rand_range(0, 3)].instance()
		add_child(resource)
		resource.global_position = position
		
	for i in Data.resources_amount["orange"].objective + 15:
		var position: Vector2 = Vector2(rand_range(-5700, 7700), rand_range(-2500,590))
		var resource = list_resources[rand_range(0, 3)].instance()
		add_child(resource)
		resource.global_position = position
		
func generate_enemys() -> void:
	
	for i in amount_enemys:
		var position: Vector2 = Vector2(rand_range(-5700, 7700), rand_range(-2500,590))
		var enemy = list_air_enemys[rand_range(0, 2)].instance()
		add_child(enemy)
		enemy.global_position = position
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	print(get_tree().change_scene("res://Scenes/game_interface/Menu.tscn"))
	if anim_name == 'show_message':
		get_tree().change_scene("res://Scenes/Game_play/phases/phase_1.tscn")
		print("acabou muda")

func _on_end_timer_timeout():
	if not get_result():
		current_second -= 1
		change_progrees_timer()
