extends Control
const ScrollAnimationName = "ScrollItems"
const ItemsPerGrid = 20 
@onready var _scroll_container := $HBoxMain/ControlItemColumn/VBoxItemColumn/HBoxInventoryItem/ScrollContainerItemGrids
@onready var _item_grids_container := $HBoxMain/ControlItemColumn/VBoxItemColumn/HBoxInventoryItem/ScrollContainerItemGrids/HBoxItemGridsContainer
# Called when the node enters the scene tree for the first time.
var _grid_template := preload("res://Scenes/UI/UI_Elements/grid_items_container.tscn")
var _ui_inventory_grid_item := preload("res://Scenes/UI/UI_Elements/ui_inventory_grid_item.tscn")


var _current_scroll_page := 1 
var _amount_scroll_pages := 1
var _page_size := 0.0
var _scroll_animation : Animation
var _is_scrolling := false
var _scrolling_to_page := 1



#
# Category members
#

@onready var _grid_categories := $HBoxMain/ControlItemColumn/VBoxItemColumn/VBoxInventoryCategories/CenterContainer/GridContainer
@onready var _label_category_name := $HBoxMain/ControlItemColumn/VBoxItemColumn/VBoxInventoryCategories/ControlCatagoryLabelParent/LabelCatagoryName
@onready var _timer_category_name : Timer = $HBoxMain/ControlItemColumn/VBoxItemColumn/VBoxInventoryCategories/ControlCatagoryLabelParent/TimerCategoryName

var _ui_inventory_category := preload("res://Scenes/UI/UI_Elements/ui_inventory_category.tscn")

var _category_displays_to_pages := {} 
var _category_displays_to_ui := {}
var _pages_to_category_displays := {}
var _current_active_ui_inventory_category : Control

#
# Item members
#

@onready var _animation_player : AnimationPlayer = $HBoxMain/ControlItemColumn/VBoxItemColumn/HBoxInventoryItem/AnimationPlayer


@onready var _button_left := $HBoxMain/ControlItemColumn/VBoxItemColumn/HBoxInventoryItem/ControlLeftColumn/ButtonLeft
@onready var _button_right := $HBoxMain/ControlItemColumn/VBoxItemColumn/HBoxInventoryItem/ControlRightColumn/ButtonRight
@onready var _ui_item_info := $HBoxMain/ControlInfoColumn/UIItemInfo
@onready var _context_menu_container := $UIContextMenuContainer
@onready var _context_menu := $UIContextMenuContainer/UIInventoryItemContextMenu

# To keep track of item highlights with mouse hover
var _current_ui_inventory_item_selected : Node






func _ready():
	_scroll_animation = _animation_player.get_animation(ScrollAnimationName)
	_reload()
	
	
func _reload() -> void:
	_reload_items()
	
	
func _reload_items() -> void:

	var pages := 0
	
	for child in _item_grids_container.get_children():
		_item_grids_container.remove_child(child)
		
	var grid
	var amount_items := 0
	
	
	for item in GameState.player_data.inventory:
		if not item:
			continue
		amount_items += 1
		
		var is_page_full := ((amount_items - 1) % ItemsPerGrid) ==0
		if not grid or (grid and is_page_full):
			grid = _grid_template.instantiate()
			
			for child in grid.get_children():
				grid.remove_child(child)
				
				
				
			_item_grids_container.add_child(grid)
			
		var ui_grid_item = _ui_inventory_grid_item.instantiate()
		ui_grid_item.set_name(item.resource_name)
		grid.add_child(ui_grid_item)
		
		var ui_inventory_item = ui_grid_item.get_ui_inventory_item()
		ui_inventory_item.set_item(item)
		
		
		var button = ui_inventory_item.get_button()
		#Callable(self, "_on_button_item_mouse_entered").bind(ui_inventory_item)
		button.mouse_entered.connect( Callable(self, "_on_button_item_mouse_entered").bind(ui_inventory_item))
		button.mouse_exited.connect( Callable(self, "_on_button_item_mouse_exited").bind(ui_inventory_item))
		button.connect("pressed", Callable(self, "on_button_item_mouse_pressed"))
		#button.connect("mouse_entered", Callable (self, "_on_button_item_mouse_entered", [ui_inventory_item]))
		#button.connect("mouse_exited", Callable( self, "_on_button_item_mouse_exited"))
		
		
		
		
	# HACK: This is needed so the container 
	# can have its size updated after the children grid were added dynamically
	_item_grids_container.set_visible(false)
	await get_tree().create_timer(0.0001).timeout
	_item_grids_container.set_visible(true)
	#sScrolling Setup
	_current_scroll_page = 1
	_amount_scroll_pages = _item_grids_container.get_child_count()
	
	if _amount_scroll_pages > 0:
		_page_size = _item_grids_container.get_size().x / _amount_scroll_pages
		
	_scroll_container.set_h_scroll(0)
	
func _on_ButtonLeft_pressed() -> void:
	_go_to_item_page(_current_scroll_page - 1)


func _on_ButtonRight_pressed() -> void:
	_go_to_item_page(_current_scroll_page + 1)
	
func _on_button_item_mouse_pressed(ui_inventory_item : Node) -> void:
	if _is_scrolling: return
	ui_inventory_item.highlight()
	_open_context_menu(ui_inventory_item)
	
func _open_context_menu(ui_inventory_item : Node) -> void:
	_context_menu.set_ui_inventory_item(ui_inventory_item)
	_context_menu_container.set_visible(true)

func _context_menu_close() -> void:
	_context_menu_container.set_visible(false)
	
	if _context_menu.get_ui_inventory_item():
		_context_menu.get_ui_inventory_item().dehighlight()
		_context_menu.set_ui_inventory_item(null)
func _on_context_menu_button_cancel_pressed() -> void:
	_context_menu_close()
func _go_to_item_page(go_to_page : int) -> void:
	if _is_scrolling:
		return
		
	go_to_page = int(clamp(go_to_page, 1, _amount_scroll_pages))
	
	if go_to_page == _current_scroll_page:
		return
		
	var from := 0.0
	var to := 0.0
	var is_forward := go_to_page > _current_scroll_page
	
	# Forward/Right
	if is_forward:
		if _current_scroll_page > 1:
			# Current Page/Current Frame
			from = _page_size * (_current_scroll_page - 1)
			
		if _current_scroll_page < _amount_scroll_pages:
			# Destination Page/Destination Frame
			to = _page_size * (go_to_page - 1)
		
	# Backward/Left
	else:
		var amount_pages_to_go = _current_scroll_page - go_to_page
		# Current Page/Current Frame
		to = _page_size * (_current_scroll_page - 1)
		# Destination Page/Destination Frame (because it's
		# goin to be played backwards) 
		from = _page_size * (_current_scroll_page - amount_pages_to_go - 1)

	_scroll_animation.track_set_key_value(0, 0, int(from))
	_scroll_animation.track_set_key_value(0, 1, int(to))	
	
	_scrolling_to_page = go_to_page
	_is_scrolling = true
	
	if is_forward:
		_animation_player.play(ScrollAnimationName)
	else:
		_animation_player.play_backwards(ScrollAnimationName)
	
func _update_navigation() -> void:
	if _current_scroll_page == 1:
		_button_left.set_visible(false)
	else:
		_button_left.set_visible(true)
		
	if _current_scroll_page == _amount_scroll_pages or _amount_scroll_pages == 0:
		_button_right.set_visible(false)
	else:
		_button_right.set_visible(true)
		
	_is_scrolling = false
	
	#_set_active_category_display()


func _on_animation_player_animation_finished(anim_name):
	_current_scroll_page = _scrolling_to_page
	_update_navigation()
func _on_button_category_mouse_entered(ui_inventory_category : Node) -> void:
	_timer_category_name.stop()
	#_show_category_display_label(ui_inventory_category)


func _on_button_category_mouse_exited(ui_inventory_category : Node) -> void:
	var category_display = _pages_to_category_displays[_scrolling_to_page]
	var ui = _category_displays_to_ui.get(category_display)
	
	if ui and ui == ui_inventory_category:
		return
	
	ui_inventory_category.dehighlight()	
	
	# Show the active category label again
	_timer_category_name.stop()
	_timer_category_name.start()
func _on_button_item_mouse_entered(ui_inventory_item : Node) -> void:
	if _is_scrolling: return
	ui_inventory_item.select()
	_show_item_info(ui_inventory_item.get_item())

func _on_button_item_mouse_exited(ui_inventory_item : Node) -> void:
	if _is_scrolling: return

#	if _context_menu.get_ui_inventory_item() and _context_menu.get_ui_inventory_item() == ui_inventory_item:
#		return

	ui_inventory_item.deselect()
	
func _show_item_info(item : EntityItem) -> void:
	_ui_item_info.set_item(item)
	_ui_item_info.set_visible(true)
