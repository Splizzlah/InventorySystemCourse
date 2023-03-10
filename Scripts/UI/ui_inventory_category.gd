extends Control

@export var item_active_modulate_color := Color(1.0, 1.0, 1.0, 2.0)
@export var item_inactive_modulate_color := Color(1.0, 1.0, 1.0, 1.0)
@export var is_active := false

@onready var _button := $CenterContainerIcon/ButtonCategoryIcon
var category: EntityItemCategoryDisplay: get = get_category, set = set_category


func set_category(value : EntityItemCategoryDisplay) -> void:
	category = value
	_button.set_texture_normal(category.texture_icon)


func get_category() -> EntityItemCategoryDisplay:
	return category


func get_button() -> Node:
	return _button



func highlight(force : bool = false) -> void:
	if force or is_active:
		set_modulate(item_active_modulate_color)



func dehighlight(force : bool = false) -> void:
	if force or not is_active:
		set_modulate(item_inactive_modulate_color)
		
		
		
func set_active(active : bool = true) -> void:
	is_active = active
	highlight() if active else dehighlight()
