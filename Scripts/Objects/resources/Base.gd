extends Area2D
class_name CollectBase


func collected(name: String) -> void:
	Data.resources_amount[name].amount += 1
	get_tree().call_group("setings", "update_info")
	queue_free()
	
