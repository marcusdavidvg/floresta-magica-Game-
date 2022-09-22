extends KinematicBody2D

onready var animated_sprite: AnimatedSprite = get_node("animates")
onready var camera: Camera2D = get_node("Camera2D")
onready var particles_water: Particles2D = get_node("bubles_water")
onready var timer_water: Timer = get_node("timer_in_water")
onready var progress_water: TextureProgress = get_node("ui/progress_water")
onready var phase_1: Node2D = get_parent()

export(float) var gravity_acceleration
export(int) var limit_speed
export(int) var jump_height
export(int) var distance_camera = 300
export(int) var speed_camera = 140
export(int) var amount_init_arrows
export(int) var max_hearth
export(int) var limit_time_in_water
export(int) var bonus_hearth

var seconds_in_water: int
var speed_move: int
var direction_arrow: Vector2
var can_move: bool = true
var velocity: Vector2
var hearth: int

enum MODE_ATTACK {close, shoot}

func _ready():
	Data.amount_arrows = amount_init_arrows
	add_to_group("player")
	hearth = max_hearth
	speed_move = limit_speed
	seconds_in_water = 0


func change_animation(name: String) -> void:
	animated_sprite.play(name)

func get_input(delta) -> void:
	velocity.x = 0
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		animated_sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x += 1
		animated_sprite.flip_h = false
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump(jump_height)
		
	if Input.is_action_pressed("zoom_camera"):
		change_position_camera(delta)
	else:
		reset_position_camera(delta)

	if Input.is_action_pressed("spider_move") and direction_arrow != Vector2.ZERO:
		spider_movement()

func jump(force: int) -> void:
	velocity.y -= force
	change_animation("jump")
	
func move_the_player(delta) -> void:
	
	if is_on_water() and not Input.is_action_pressed("jump"):
		velocity.y = 26.0 * delta
		speed_move = 300

	if not is_on_water():
		animated_sprite.flip_v = false
		velocity.y += 6.6 * delta
		speed_move = limit_speed
		
	move_and_slide(velocity * speed_move, Vector2.UP)
	
	if velocity.x == 0:
		change_animation("idle")
	else:
		change_animation("walk")
	
	if is_on_floor():
		velocity.y = 0


func _physics_process(delta):
	get_input(delta)
	
	if can_move:
		move_the_player(delta)
		
	Data.position_player = global_position
	Data.is_on_water = is_on_water()
	
	set_position_camera()
	change_ui_info()
	phase_1.move_background()
	
	if is_on_water():
		move_in_water(delta)
	else:
		seconds_in_water = 0
		rotation_degrees = 0
		timer_water.stop()
	
	particles_water.emitting = is_on_water()
	particles_water.visible = is_on_water()
	progress_water.visible = is_on_water()

	
func set_position_camera() -> void:
	if position.x > 7540 or position.y > 1482 or position.x < -5415 or position.y < -2656:
		camera.current = false
	else:
		camera.current = true
		
func move_in_water(delta) -> void:
	
	if timer_water.is_stopped():
		timer_water.start()
		
	if seconds_in_water >= limit_time_in_water:
		defeat()
	
	if Data.amount_arrows < 1:
		defeat()
		return
	
	if Input.is_action_pressed("jump"):
		velocity.y = -1.6
		if rotation_degrees > 50 and velocity.x > 0:
			rotation_degrees -= 50 * delta
		elif rotation_degrees < -50 and velocity.x < 0:
			rotation_degrees += 50 * delta 
			
	else:
		if rotation_degrees <= 90:
			rotation_degrees += 50 * delta
	
	if position.y > 1994:
		defeat()
	
	if Input.is_action_pressed("move_left"):
		animated_sprite.flip_v = true
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("move_right"):
		animated_sprite.flip_v = false
		animated_sprite.flip_h = false
	
	particles_water.look_at(Vector2.UP)
	particles_water.rotation_degrees -= 90
	
	
func spider_movement() -> void:
	
	var direction: Vector2 = global_position.direction_to(direction_arrow)
	
	if not is_on_ceiling():
		velocity = Vector2.ZERO
		move_and_slide(direction.normalized() * (speed_move * 3))

func change_position_camera(delta) -> void:
	var direction: Vector2 = global_position.direction_to(get_global_mouse_position())
	
	if camera.position.distance_to(Vector2.ZERO) < distance_camera:
		camera.translate(direction.normalized() * speed_camera * delta)
		
func reset_position_camera(delta) -> void:
	if camera.position.distance_to(Vector2.ZERO) > 60:
		var direction: Vector2 = camera.position.direction_to(Vector2.ZERO)
		
		camera.translate(direction.normalized() * (speed_camera * 2) * delta)

func take_damage(damage: int) -> void:
	hearth -= damage
	
	get_tree().call_group("setings", "update_info")
	
	if hearth < 1:
		defeat()
		
	
func defeat() -> void:
	camera.zoom = Vector2(0.5, 0.5)
	can_move = false
	get_parent().defeat_game()
	
func is_on_water() -> bool:
	return position.y > 1192
	
func change_ui_info() -> void:
	progress_water.max_value = limit_time_in_water
	progress_water.value = seconds_in_water

func _on_animates_animation_finished():
	animated_sprite.frame = 0

func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.


func _on_timer_in_water_timeout():
	seconds_in_water += 1
	

func _on_bonus_hearth_timeout():
	if hearth < max_hearth - bonus_hearth:
		hearth += bonus_hearth
	else:
		hearth = max_hearth
