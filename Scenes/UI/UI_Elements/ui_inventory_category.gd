extends Control

@export var item_active_modulate_color := Color(1.0, 1.0, 1.0, 1.0)
@export var item_inactive_modulate_color := Color(1.0, 1.0, 1.0, 0.3)
@export var is_active := false

@onready var _button := $CenterContainerIcon/ButtonCategoryIcon
var category: EntityItemCategoryDisplay: get = get_category, set = set_category



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_category(value : EntityItemCategoryDisplay) -> void:
	category = value
	_button.set_texture_normal(category.texture_icon)


func get_category() -> EntityItemCategoryDisplay:
	return category


func get_button() -> Node:
	return _button

