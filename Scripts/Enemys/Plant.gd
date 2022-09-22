extends StaticBody2D

export(int) var damage
export(int) var limit_hearth

var is_detect_player: bool
var is_recarge: bool = true
var hearth: int

var object_attack = preload("res://Scenes/Objects/Enemys/skullAttack.tscn")

onready var exit_attack: Position2D = get_node("exit_attack")
onready var timer_recarge: Timer = get_node("recarge_shoot")
onready var animation: AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	add_to_group("enemys")
	hearth = limit_hearth

func shoot_bullet() -> void:
	var bullet = object_attack.instance()
	add_child(bullet)
	bullet.global_position = exit_attack.global_position
	is_recarge = false
	timer_recarge.start()
	
func _process(delta):
	if visible:
		if is_detect_player:
			if is_recarge:
				animation.play("attack")
				
				
func take_damage(dmg: int) -> void:
	hearth -= dmg
	
	if hearth < 1:
		dead()
		
func dead() -> void:
	queue_free()

func _on_detect_area_body_entered(body):
	is_detect_player = true
func _on_detect_area_body_exited(body):
	is_detect_player = false


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_recarge_shoot_timeout():
	is_recarge = true


func _on_AnimationPlayer_animation_finished(anim_name):
	shoot_bullet()
