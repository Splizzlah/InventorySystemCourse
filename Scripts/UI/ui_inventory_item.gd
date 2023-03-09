extends Control

var item: EntityItem : set = set_item, get = get_item
@onready var _texture_item_sprite := $UIFrame/TextureItemBackground/TextureItemSprite
@onready var _button : TextureButton = $UIFrame/ButtonSelection



func _ready() -> void:
	deselect()
	_button.set_visible(true)


func set_item(value : EntityItem) -> void:
	item = value
	_texture_item_sprite.set_texture(item.texture_icon)
	
	
func get_item() -> EntityItem:
	return item

func select() -> void:
	_button.set_modulate(Color(1.0, 1.0, 1.0, 1.0))

func deselect() -> void:
	_button.set_modulate(Color(1.0, 1.0, 1.0, 0.0))



func get_button() -> TextureButton:
	return _button
