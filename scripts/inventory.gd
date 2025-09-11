extends Control

@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var slot_container = $background/MarginContainer/VBoxContainer/GridContainer
@onready var item_scene = preload("res://scenes/item.tscn")
@onready var col_count = slot_container.columns

var grid_array := []
var item_held = null
var current_slot = null
var can_place = false
var icon_anchor : Vector2

func _ready() -> void:
	for i in range(64):
		create_slot()

func create_slot() -> void:
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	slot_container.add_child(new_slot)
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)

func _on_slot_mouse_entered(a_slot):
	icon_anchor = Vector2(10000,10000)
	current_slot = a_slot
	if item_held:
		check_slot_availability(current_slot)
		set_grids.call_deferred(current_slot)

func _on_slot_mouse_exited(a_slot):
	pass

func _on_button_pressed() -> void:
	var new_item = item_scene.instantiate()
	add_child(new_item)
	new_item.load_item(1)
	new_item.selected = true
	item_held = new_item

func check_slot_availability(a_slot) -> void:
	for grid in item_held.item_grids:
		var grid_to_check = a_slot.slot_ID + grid[0] + grid[1] * col_count
		var line_switch_check = a_slot.slot_ID % col_count + grid[0]
		if line_switch_check < 0 or line_switch_check >= col_count:
			can_place = false
			return
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			can_place = false
			return
		if grid_array[grid_to_check].state == grid_array[grid_to_check].States.TAKEN:
			can_place = false
			return
	can_place = true

func set_grids(a_slot) -> void:
	for grid in item_held.item_grids:
		var grid_to_check = a_slot.slot_ID + grid[0] + grid[1] * col_count
		var line_switch_check = a_slot.slot_ID % col_count + grid[0]
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			continue
		if line_switch_check < 0 or line_switch_check >= col_count:
			continue
		if can_place:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.FREE)
			
			if grid[1] < icon_anchor.x: 
				icon_anchor.x  = grid[1]
			if grid[0] < icon_anchor.y: 
				icon_anchor.y = grid[0]
		else:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.TAKEN)
