extends ControlWithItem

#var item: EntityItem : set = set_item, get = get_item
@onready var _texture_item_sprite := $UIFrame/TextureItemBackground/TextureItemSprite
@onready var _button : TextureButton = $UIFrame/ButtonSelection 
#@onready var _animation_player := $UIFrame/AnimationPlayer
@onready var _texture_background := $UIFrame/TextureItemBackground

var _texture_background_normal := preload("res://Assets/UI/ButtonBackgrounds/Highlight-Normal.png")
var _texture_background_equipped := preload("res://Assets/UI/ButtonBackgrounds/Highlight-Equipped.png")

var _is_highlighted := false
func _ready() -> void:
	deselect()
	_button.set_visible(true)
func set_item(value : EntityItem) -> void:
	item = value
	_texture_item_sprite.set_texture(item.texture_icon)
	
	
func get_item() -> EntityItem:
	return item
	
	
func get_button() -> TextureButton:
	return _button
	
	
func deselect() -> void:
	_button.set_modulate(Color(1.0, 1.0, 1.0, 0.0))
	#dehighlight()
	
	
func select() -> void:
	_button.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
