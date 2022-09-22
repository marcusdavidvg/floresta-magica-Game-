extends CollectBase



func _on_resource_orange_area_entered(area):
	collected('orange')


func _on_resource_orange_body_entered(body):
	collected('orange')
	get_node("collect").stop()
	get_node("collect").play()


func _on_world_body_entered(body):
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false


func _on_collect_finished():
	get_node("collect").stop()
