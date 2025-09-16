extends Node2D

@onready var IconNode = $Icon

var Item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null

func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func load_item(a_ItemID : int) -> void:
	var Icon_path = "res://assets/" + DataHandler.item_data[str(a_ItemID)]["Name"] + ".png"
	IconNode.texture = load(Icon_path)
	IconNode.size = Vector2(DataHandler.item_data[str(a_ItemID)]["Sizex"], DataHandler.item_data[str(a_ItemID)]["Sizey"])
	for grid in DataHandler.item_grid_data[str(a_ItemID)]:
		var converter_array := []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)

func rotate_item():
	for grid in item_grids:
		var temp_y = grid[0]
		grid[0] = -grid[1]
		grid[1] = temp_y
	rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0

func _snap_to(destination: Vector2):
	var tween = get_tree().create_tween()
	if int(rotation_degrees) % 180 == 0:
		destination += IconNode.size / 2
	else:
		var temp_xy_switch = Vector2(IconNode.size.y, IconNode.size.x)
		destination += temp_xy_switch / 2
	print(destination, " destynacja")
	print("IconNode.size:", IconNode.size)
	tween.tween_property(self, "global_position", destination, 0.15).set_trans(Tween.TRANS_SINE)
	selected = false
