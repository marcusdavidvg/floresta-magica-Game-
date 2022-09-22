extends Node2D

onready var sprite:AnimatedSprite = get_node("Sprite")
onready var position_spawn_fire_ball: Vector2 = get_node("Sprite/Position2D").global_position
onready var timer_recarge: Timer = get_node("recarge_fire_ball")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var tool_effects: AnimatedSprite = get_node("effectsTool")
onready var area_damage: Area2D = get_node("damage")
onready var ui: CanvasLayer = get_node("ui")
onready var sprite_close: Sprite = get_node("damage/Sprite2")

export(int) var damage_close

var fire_ball_scene = preload("res://Scenes/Objects/tool/fire_ball.tscn")

var current_mode: String #shoot / close

var is_recarge: bool = true

func _ready():
	current_mode = 'shoot'
	update_info()
	randomize()

func fast_attack() -> void:
	reset_attack()
	var fire_ball = fire_ball_scene.instance()
		
	get_parent().get_parent().add_child(fire_ball)
	fire_ball.global_position = get_parent().global_position
	
	is_recarge = false
	timer_recarge.start()
	
	Data.amount_arrows -= 1
	get_tree().call_group("setings", "update_info")
	
func close_attack() -> void:
	reset_animation(false)
	var enemys: Array = area_damage.get_overlapping_bodies()
	
	area_damage.look_at(get_global_mouse_position())
	
	animation_player.play("close")
	if enemys.size() > 0:
		if rand_range(0, 10) > 6:
			enemys[0].take_damage(damage_close)
			get_node("hit").stop()
			get_node("hit").play()
		

func reset_attack() -> void:
	sprite.frame = 0
	sprite.modulate.a = 1
	sprite.stop()
	
func press_attack() -> void:
	print("pressionado")
	
func _input(event):
	if Input.is_action_just_pressed("one"):
		current_mode = "close"
		update_info()
	elif Input.is_action_just_pressed("two"):
		current_mode = "shoot"
		update_info()
	
func get_input() -> void:
	
	if Input.is_action_just_pressed("attack") and is_recarge:
		reset_animation(true)
		if current_mode == 'shoot' and Data.amount_arrows >= 1:
			animation_player.play("init_fire")
			sprite.play("attack")

		
	if Input.is_action_pressed("attack"):
		if current_mode == "close":
			close_attack()
	

func _process(delta):
	look_at(get_global_mouse_position())
	get_input()

func reset_animation(value:bool) -> void:
	get_node("init").visible = value

	
func update_info() -> void:
	for icon in ui.get_children():
		if icon.name == current_mode:
			icon.rect_scale = Vector2(2,2)
		else:
			icon.rect_scale = Vector2(1,1)
	
	if current_mode == "shoot":
		tool_effects.visible = false
		tool_effects.stop()
		sprite_close.visible = false
		sprite.visible = true
	elif current_mode == "close":
		tool_effects.visible = true
		tool_effects.play("close")
		sprite_close.visible = true
		sprite.visible = false
	
	
func _on_recarge_fire_ball_timeout():
	is_recarge = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "init_fire":
		reset_animation(false)

func _on_Sprite_animation_finished():
	fast_attack()
