extends Node2D

@onready var IconNode = $Icon

var Item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null

func _ready() -> void:
	load_item(1)
	selected = true

func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func load_item(a_ItemID : int) -> void:
	var Icon_path = "res://assets/" + DataHandler.item_data[str(a_ItemID)]["Name"] + ".png"
	IconNode.texture = load(Icon_path)
	for grid in DataHandler.item_grid_data[str(a_ItemID)]:
		var converter_array := []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)
