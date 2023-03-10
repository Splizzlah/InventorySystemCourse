extends ControlWithItem


@onready var _texture_item_sprite := $UIFrame/TextureItemBackground/TextureItemSprite
@onready var _button : TextureButton = $UIFrame/ButtonSelection
@onready var _animation_player := $AnimationPlayer
@onready var _texture_background := $UIFrame/TextureItemBackground
var _texture_background_normal := preload("res://Assets/UI/ButtonBackgrounds/Highlight-Normal.png")
var _texture_background_equipped := preload("res://Assets/UI/ButtonBackgrounds/Highlight-Equipped.png")


var _is_highlighted := false


func _ready() -> void:
	deselect()
	_button.set_visible(true)
	
	Events.connect("on_item_equipped", Callable( self, "_on_item_equipped"))
	Events.connect("on_item_unequipped", Callable( self, "_on_item_unequipped"))

func set_item(value : EntityItem) -> void:
	super.set_item(value)
	_texture_item_sprite.set_texture(item.texture_icon)
	_sync_item_equipped()
	


func select() -> void:
	_button.set_modulate(Color(1.0, 1.0, 1.0, 1.0))

func deselect() -> void:
	_button.set_modulate(Color(1.0, 1.0, 1.0, 0.0))
	dehighlight()


func highlight() -> void:
	_animation_player.play("Highlight")
	_is_highlighted = true
	
	
func dehighlight() -> void:
	if _is_highlighted:
		_animation_player.play("DeHighlight")
		_is_highlighted = false
		
		
func get_button() -> TextureButton:
	return _button
	
	
func _sync_item_equipped() -> void:
	var texture : Texture
	
	if GameState.player_check_is_item_equipped(item):
		texture = _texture_background_equipped
	else:
		texture = _texture_background_normal
		
	_texture_background.set_texture(texture)


func _on_item_equipped(_item : EntityItem) -> void:
	if _item == item:
		_sync_item_equipped()


func _on_item_unequipped(_item : EntityItem) -> void:
	if _item == item:
		_sync_item_equipped()
