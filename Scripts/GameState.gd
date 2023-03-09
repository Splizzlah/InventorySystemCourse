extends Node
const ItemCategoryDisplaysPath = "res://Data/ItemCategoryDisplays/"
var player_data : EntityPlayer

var _default_player : EntityPlayer = preload("res://Data/DefaultPlayer.tres")
var item_category_displays : Array = []

func _init() -> void:
	item_category_displays = FileUtils.load_resources_from_path(ItemCategoryDisplaysPath)
	player_data = _default_player.duplicate()
	player_data.make_inventory_unique()


func get_inventory_items_from_category(category: int) -> Array:
	return player_data.get_inventory_by_category().get(category, [])


func count_inventory_items_from_category_display(display : EntityItemCategoryDisplay) -> int:
	var inventory_by_category := player_data.get_inventory_by_category()
	var count := 0
	
	for category in display.types:
		if inventory_by_category.has(category):
			count += inventory_by_category[category].size()
			
	return count


func player_check_is_item_equipped(item : EntityItem) -> bool:
	var property = player_data.get_equipped_property_for_item(item)
	return player_data.get(property) == item
	
	
func player_equip_item(item : EntityItem) -> void:
	var property = player_data.get_equipped_property_for_item(item)
	var currently_equipped = player_data.get(property)
	
	if currently_equipped and currently_equipped != item:
		player_unequip_item(currently_equipped)
		
	player_data.set(property, item)	
	#Events.emit_signal("on_item_equipped", item)
	
	var has_equipped_two_handed = player_data.equipped_weapon and player_data.equipped_weapon.is_two_handed()
	var is_equipping_two_handed = item.is_two_handed()
	
	# A TwoHanded item has been just equipped, but the player has an OffHand equipped,
	# unequip the off hand (currently only Shields)
	if (is_equipping_two_handed and player_data.equipped_off_hand):
		player_unequip_item(player_data.equipped_off_hand)
	
	# Shield has just been equipped, but the player has a TwoHandedWeapon equipped,
	# unequip the weapon
	elif (item.category_type == Types.ItemCategoryTypes.Shields and has_equipped_two_handed):
		player_unequip_item(player_data.equipped_weapon)
		
	
func player_unequip_item(item : EntityItem) -> void:
	var property = player_data.get_equipped_property_for_item(item)
	player_data.set(property, null)
	#Events.emit_signal("on_item_unequipped", item)
	
	
func acquire_item(item : EntityItem) -> void:
	player_data.append_to_inventory(item.duplicate())
	#Events.emit_signal("on_item_acquired", item)
	
	
	
