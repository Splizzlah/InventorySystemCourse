extends Resource
class_name EntityPlayer

@export var inventory :Array[Resource] = []
#var inventory_by_category: get = get_inventory_by_category
var inventory_by_category: Dictionary:
	set(new_value):
		inventory_by_category = {}
		for item in inventory:
			if item is EntityItem:
				if inventory_by_category.has(item.category_type):
					inventory_by_category[item.category_type].append(item)
				else:
					inventory_by_category[item.category_type] = [item]
				
	get:
		
		return inventory_by_category


func make_inventory_unique() -> void:
	
	if not inventory.is_empty():
		for idx in range(inventory.size()):
			if inventory[idx]:
				inventory[idx] = inventory[idx].duplicate()

func index_inventory() -> void:       # This is the setter
	inventory_by_category = {}
	for item in inventory:
		if item is EntityItem:
			if inventory_by_category.has(item.category_type):
				inventory_by_category[item.category_type].append(item)
			else:
				inventory_by_category[item.category_type] = [item]
				
func get_inventory_by_category() -> Dictionary:    #  The Getter
	if inventory_by_category:
		return inventory_by_category
	else:
		index_inventory()
	return inventory_by_category
