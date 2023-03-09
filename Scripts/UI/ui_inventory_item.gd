extends Control

var item: EntityItem : set = set_item, get = get_item
@onready var _texture_item_sprite := $UIFrame/TextureItemBackground/TextureItemSprite


func set_item(value : EntityItem) -> void:
	item = value
	_texture_item_sprite.set_texture(item.texture_icon)
	
	
func get_item() -> EntityItem:
	return item

