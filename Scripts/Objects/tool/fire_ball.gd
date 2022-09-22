extends Area2D

var direction: Vector2
export(int) var speed = 300
export(int) var damage = 50

onready var position_collision_arrow: Vector2 
onready var node_player: KinematicBody2D = get_parent().get_node("player")

var can_attack: bool = false

func _ready():
	direction = global_position.direction_to(get_global_mouse_position() - node_player.global_position)
	rotate(direction.angle())
	can_attack = true
	
func _process(delta):
	if direction and can_attack:
		global_translate(direction.normalized() * speed * delta)
		

func collide_detect(object) -> void:
	can_attack = false
	node_player.direction_arrow = get_node("Position2D").global_position
	
	get_node("AnimatedSprite").visible = false
	

#func _on_VisibilityNotifier2D_screen_exited():
#	queue_free()


func _on_fire_ball_body_entered(body):
	if body.is_in_group('enemys'):
		get_node("hit").stop()
		get_node("hit").play()
		body.take_damage(damage)
		queue_free()
	else:
		collide_detect(body)
