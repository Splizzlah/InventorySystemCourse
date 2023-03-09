extends Node
const ItemCategoryDisplaysPath = "res://Data/ItemCategoryDisplays/"
var player_data : EntityPlayer

var _default_player : EntityPlayer = preload("res://Data/DefaultPlayer.tres")
var item_category_displays : Array

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
