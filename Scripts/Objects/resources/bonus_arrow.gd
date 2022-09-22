extends Area2D



func _on_bonus_arrow_body_entered(body):
	Data.amount_arrows += 8
	get_tree().call_group("setings", 'update_info')
	get_node("collect").play()
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false


func _on_collect_finished():
	get_node("collect").stop()
