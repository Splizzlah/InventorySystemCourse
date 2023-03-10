extends ControlWithItem


@onready var _texture_item_sprite := $UIFrame/TextureItemBackground/TextureItemSprite
@onready var _button : TextureButton = $UIFrame/ButtonSelection
@onready var _animation_player := $AnimationPlayer

var _is_highlighted := false
func _ready() -> void:
	deselect()
	_button.set_visible(true)


func set_item(value : EntityItem) -> void:
	super.set_item(value)
	_texture_item_sprite.set_texture(item.texture_icon)
	
	


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
