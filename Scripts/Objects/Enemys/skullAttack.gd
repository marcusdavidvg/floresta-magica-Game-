extends Area2D

var direction: Vector2
var speed: int = 1400
var damage: int = 50

func _ready():
	direction = global_position.direction_to(Data.position_player)
	
	
func _process(delta):
	if direction:
		global_translate(direction.normalized() * speed * delta)
	
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_skullAttack_body_entered(body):
	if body.name == "player":
		body.take_damage(damage)
		queue_free()
