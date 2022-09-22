extends CollectBase



func _on_resource_green_area_entered(area):
	collected('green')


func _on_resource_green_body_entered(body):
	collected('green')
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
