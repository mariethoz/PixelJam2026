class_name HotKey extends Control

@onready var action_label = %ActionLabel
@onready var default_label = %DefaultLabel
@onready var button = %Button

var action_key: ActionKey

func _ready():
	set_process_unhandled_input(false)

func set_action(value):
	action_key = value
	action_label.text = action_key.name
	default_label.text = action_key.default.as_text()
	button.text = action_key.event.as_text()

	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var s = KeybindManager.update_key(event, action_key)
		if s:
			button.text = event.as_text()
		set_process_unhandled_input(false)
