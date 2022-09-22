extends StaticBody2D

onready var sprite: AnimatedSprite = get_node("Sprites")

export(int) var force_jump

func _ready():
	sprite.frame = 0

func _on_Sprites_animation_finished():
	sprite.frame = 0
	sprite.stop()

func _on_detect_collision_body_entered(body):
	body.jump(force_jump)
	sprite.play("jump")
	print("bateu")
