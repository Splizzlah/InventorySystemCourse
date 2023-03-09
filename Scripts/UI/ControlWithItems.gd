extends Control
class_name ControlWithItem

var item : EntityItem: set = set_item, get = get_item


func get_item() -> EntityItem:
	return item
	
	
func set_item(value : EntityItem) -> void:
	item = value
