extends Node2D



func _on_VisibilityNotifier2D_screen_entered():
	visible = true
func _on_VisibilityNotifier2D_screen_exited():
	visible = false
