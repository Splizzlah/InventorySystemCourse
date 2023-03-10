extends ControlWithItem

@onready var _label_item_name : Label = $VBoxContainer/VBoxNameAndTypeContainer/HBoxNameAndTypeContainer/LabelItemName
@onready var _label_item_type : Label = $VBoxContainer/VBoxNameAndTypeContainer/HBoxNameAndTypeContainer/LabelItemType
@onready var _hbox_attack := $VBoxContainer/HBoxMainStats/HBoxAttack
@onready var _hbox_defense := $VBoxContainer/HBoxMainStats/HBoxDefense
@onready var _hbox_price := $VBoxContainer/HBoxMainStats/HBoxPrice
@onready var _hbox_special := $VBoxContainer/HBoxSpecialStats/HBoxSpecial
@onready var _hbox_effect := $VBoxContainer/HBoxSpecialStats/HBoxEffect
@onready var _label_description : RichTextLabel = $VBoxContainer/LabelDescription


func _ready() -> void:
	_label_item_name.set_text("Browse, Equip and Unequip Items")
	_label_item_type.set_text("")
	
	_hbox_attack.set_visible(false)
	_hbox_defense.set_visible(false)
	_hbox_price.set_visible(false)
	_hbox_special.set_visible(false)
	_hbox_effect.set_visible(false)
	_label_description.set_visible(false)


func set_item(value : EntityItem) -> void:
	super.set_item(value)
	
	_label_item_name.set_text(item.name)
	_label_item_type.set_text("(" + Types.ItemCategoryTypes.keys()[item.category_type] + ")")
	
	_hbox_attack.set_value(str(item.attack_power))
	_hbox_attack.set_visible(true)
	
	_hbox_defense.set_value(str(item.defense_value))
	_hbox_defense.set_visible(true)
	
	_hbox_price.set_value(str(item.price))
	_hbox_price.set_visible(true)

	if item.effect:
		_hbox_effect.set_value(item.effect)
		_hbox_effect.set_visible(true)
	else:
		_hbox_effect.set_visible(false)
	
	if item.special_trait:
		_hbox_special.set_value(item.special_trait)
		_hbox_special.set_visible(true)
	else:
		_hbox_special.set_visible(false)
		
	if item.description:
		
		_label_description.parse_bbcode("[i]" + item.description + '[/i]')

		_label_description.set_visible(true)
	else:
		_label_description.set_visible(false)
