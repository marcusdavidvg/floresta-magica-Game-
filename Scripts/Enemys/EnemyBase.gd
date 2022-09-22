extends KinematicBody2D
class_name TerrestrialEnemy

var sprite: AnimatedSprite
var recarge_timer: Timer
var navigation: Navigation2D

var speed: int
var damage: int
var distance_detect: int
var distance_attack: int

var is_recarge: bool = true
var is_fly: bool
var is_visible: bool
var is_water_enemy: bool

var velocity: Vector2
var hearth: int
var direction_player: Vector2

func _ready():
	
	add_to_group("enemys")
	randomize()
	
	speed = rand_range(340, 420)
	damage = rand_range(60, 80)
	distance_detect = rand_range(500, 1200)
	hearth =  int(rand_range(40, 250))
	
	create_timer_recarge()
	create_timer_random_move()
	
func create_timer_recarge() -> void:
	recarge_timer = Timer.new()
	recarge_timer.wait_time = 1.5
	recarge_timer.one_shot = true
	add_child(recarge_timer)
	recarge_timer.connect("timeout", self, "recarge_attack")

func create_timer_random_move() -> void:
	var timer: Timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = 10
	timer.autostart = true
	timer.connect("timeout", self, "move_random")
	add_child(timer)

func get_path_to_player() -> void:
	yield(get_tree().create_timer(0.8),"timeout")
	var path: Array = navigation.get_simple_path(self.global_position, Data.position_player, false)
	
	if not path.empty():
		direction_player = path[1]
		
	
func move_to_player(delta) -> void:
	
	get_path_to_player()
	
	if direction_player:
		if is_fly or is_water_enemy:
			velocity = global_position.direction_to(direction_player)
		else:
			velocity.x = global_position.direction_to(direction_player).x
			
		move_and_slide(velocity.normalized() * speed, Vector2.UP)
		change_sprite("walk")
		
func move_random():
	
	if is_fly:
		var positions: Array = get_tree().get_nodes_in_group("points_position")
		var direction: Vector2 = positions[rand_range(0, positions.size())].global_position
		if global_position.distance_to(direction) > 300:
			velocity = global_position.direction_to(direction)
	
func attack_the_player() -> void:
	if is_recarge:
		change_sprite("attack")
	
func damage_to_player() -> void:
	if get_distance_player() < distance_attack:
		get_tree().call_group("player", "take_damage", damage)
		is_recarge = false
		recarge_timer.start()
		
func change_sprite(name: String) -> void:
	sprite.play(name)
	sprite.flip_h = velocity.x < 0
	
func reset_sprite() -> void:
	sprite.frame = 0

func _physics_process(delta):

	if visible:
		if get_distance_player() < distance_detect and get_distance_player() > distance_attack:
			move_to_player(delta)
		elif get_distance_player() < distance_attack:
			attack_the_player()
		else:
			change_sprite('idle')
			
		if not is_fly and not is_water_enemy:
			move_and_slide(Vector2.DOWN * 90.8)
			
func is_on_area_enemy() -> bool:
	return is_water_enemy == Data.is_on_water

func take_damage(damage: int) -> void:
	get_node("hit").play()
	hearth -= damage
	
	if hearth < 1:
		dead()
		
func dead() -> void:
	
	var id: int = int(rand_range(1, 4))
	
	if rand_range(1, 10) < 3:
		if id == 1:
			Data.resources_amount["green"].amount += 1
		elif id == 2:
			Data.resources_amount["orange"].amount += 1
		elif id == 3:
			Data.resources_amount["blue"].amount += 1 
			
	get_tree().call_group("setings", "update_info")
	
	queue_free()
	
func recarge_attack() -> void:
	is_recarge = true

func get_distance_player() -> int:
	return int(global_position.distance_to(Data.position_player))
	

