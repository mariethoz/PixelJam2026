#class_name KeybindManager
extends Node

@export var keybinds: Array[ActionKey]

var config = ConfigFile.new()

func _ready():
	load_keybinds()

func get_action_keybinds():
	return keybinds
	
func get_action_keybind(action_tag: String):
	for keybind in keybinds:
		if keybind.tag == action_tag:
			return keybind
	print("No action tag: ", action_tag)
	return null

func from_key_text(key_text: String) -> InputEvent:
	var key_event = InputEventKey.new()
	key_event.keycode = OS.find_keycode_from_string(key_text)
	return key_event

func load_keybinds():
	if not keybinds:
		print("No keybinds resource assigned!")
		return

	
	for action_key in keybinds:
		if action_key.event and action_key.tag:
			InputMap.action_add_event(action_key.tag, action_key.event)

	if config.load("user://settings.cfg") == OK:
		for action_key in keybinds:
			var key = config.get_value("controls", action_key.tag, action_key.default.as_text())
			InputMap.action_erase_event(action_key.tag, action_key.event)
			action_key.event = from_key_text(key)
			InputMap.action_add_event(action_key.tag, action_key.event)

func save_keybinding(action_key: ActionKey):
	if not keybinds:
		print("No keybinds resource assigned!")
		return
		
	for keybind in keybinds:
		if action_key.tag == keybind.tag:
			keybind.event = action_key.event
			InputMap.action_add_event(action_key.tag, action_key.event)
			config.set_value("controls", action_key.tag, action_key.event.as_text())
			config.save("user://settings.cfg")
			return
	
	print("Action tag not found in keybinds:", action_key.tag)

func reset_keybindings():
	if config.load("user://settings.cfg") == OK:
		config.erase_section("controls")
		config.save("user://settings.cfg")
	
	# Reset all keys in InputMap
	for hotkey in keybinds:
		InputMap.action_erase_event(hotkey.tag, hotkey.event)
		InputMap.action_add_event(hotkey.tag, hotkey.default)
		hotkey.event = hotkey.default
		config.set_value("controls",hotkey.tag, hotkey.default.as_text())
	config.save("user://settings.cfg")

func update_key(event, action_key):
	# Check for duplicate keybinding
	for keybind in KeybindManager.get_action_keybinds():
		if keybind.event and keybind.event.as_text() == event.as_text():
			print("Key already in use!")  # Replace with a UI warning
			return

	# Assign the new key
	InputMap.action_erase_event(action_key.tag, action_key.event)
	InputMap.action_add_event(action_key.tag, event)
	action_key.event = event
	return event.as_text()
