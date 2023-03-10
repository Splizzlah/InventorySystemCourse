extends ControlWithItem

@onready var _button_cancel : Button = $VBoxButtons/ButtonCancel
@onready var _button_equip : Button = $VBoxButtons/ButtonEquip

var ui_inventory_item : Control: set = set_ui_inventory_item,  get = get_ui_inventory_item


func get_button_cancel() -> Button:
	return _button_cancel
	

func get_button_equip() -> Button:
	return _button_equip


func set_ui_inventory_item(value : Control) -> void:
	ui_inventory_item = value
	
	if value:
		set_item(value.get_item())
		
		if GameState.player_check_is_item_equipped(item):
			_button_equip.set_text("Unequip")
		else:
			_button_equip.set_text("Equip")
			
	else:
		set_item(null)
		
		
func get_ui_inventory_item() -> Control:
	return ui_inventory_item
	
