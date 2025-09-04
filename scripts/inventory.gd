extends Control

@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var slot_container = $background/MarginContainer/VBoxContainer/GridContainer

var grid_array := []

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
	a_slot.set_color(a_slot.States.FREE)

func _on_slot_mouse_exited(a_slot):
	a_slot.set_color(a_slot.States.DEFAULT)
