class_name MenuWindow extends Control

@onready var margin_container = $MarginContainer
@onready var color_rect = $ColorRect

func _ready():
	hide()

func open(child: Control):
	margin_container.add_child(child)
	color_rect.gui_input.connect(_on_gui_input)
	set_process_unhandled_input(true)
	show()
	grab_focus() # Ensure focus is inside the settings window

func clear_children():
	for child in margin_container.get_children():
		margin_container.remove_child(child)
		child.queue_free()

func _on_gui_input(event):
	print(event)
	if event is InputEventMouseButton and event.pressed:
		close()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # Detect ESC key
		close()

func close():
	clear_children()
	hide()
	margin_container.gui_input.disconnect(_on_gui_input)
	set_process_unhandled_input(false)
