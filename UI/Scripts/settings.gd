extends Control

@export var resolutions: Array[Vector2]

@onready var hot_key_scene: PackedScene = preload("res://UI/Composants/hotkey.tscn")

@onready var master_slider = %MasterSoundSlider
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var bgm_slider = %BGMSlider
@onready var fullscreen_check = %Fullscreen
@onready var resolution_option = %ResolutionOption
@onready var ui_scale_slider = %UIScaleSlider
@onready var reset_key = %ResetKey
@onready var hotkeys = %HotKeys
@onready var audio_master = %AudioMaster
@onready var audio_music = %AudioMusic
@onready var audio_sfx = %AudioSFX
@onready var audio_bgm = %AudioBGM

var config = ConfigFile.new()
var resolution: Vector2 = DisplayServer.window_get_size()

func _ready():
	_load_settings()
	_populate_resolution_option()
	_populate_command_option()
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	bgm_slider.value_changed.connect(_on_bgm_volume_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	resolution_option.item_selected.connect(_on_resolution_changed)
	#ui_scale_slider.value_changed.connect(_on_ui_scale_changed)
	reset_key.pressed.connect(_reset_hotkeys)

func _load_settings():
	if config.load("user://settings.cfg") == OK:
		master_slider.value = config.get_value("audio", "master_volume", 1.0)
		music_slider.value = config.get_value("audio", "music_volume", 1.0)
		sfx_slider.value = config.get_value("audio", "sfx_volume", 1.0)
		bgm_slider.value = config.get_value("audio", "bgm_volume", 1.0)
		
		fullscreen_check.button_pressed = config.get_value("video", "fullscreen", false)
		var r = config.get_value("video","default_resolution",resolution)
		if r not in resolutions:
			resolutions.insert(0,r)
		resolution = config.get_value("video", "resolution", resolution)
		resolution_option.selected = resolutions.find(resolution)
		#ui_scale_slider.value = config.get_value("video", "ui_scale", 1.0)
		
		_apply_settings()
	else:
		print("No settings file found, using defaults.")

func _populate_resolution_option():
	# Populate the OptionButton with the resolutions
	if resolution not in resolutions:
		resolutions.insert(0,resolution)
		config.set_value("video", "default_resolution", resolution)
		config.save("user://settings.cfg")
	for r in resolutions:
		resolution_option.add_item(str(r.x) + "x" + str(r.y))
		if r == resolution:
			resolution_option.select(resolutions.find(r))

func _apply_settings():
	AudioServer.set_bus_volume_db(0, linear_to_db(master_slider.value))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_slider.value))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_slider.value))
	AudioServer.set_bus_volume_db(3, linear_to_db(bgm_slider.value))

	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen_check.button_pressed else DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(resolution)
	get_tree().root.content_scale_factor = ui_scale_slider.value

func _on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	config.set_value("audio", "master_volume", value)
	config.save("user://settings.cfg")
	audio_master.play()

func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	config.set_value("audio", "music_volume", value)
	config.save("user://settings.cfg")
	audio_music.play()

func _on_sfx_volume_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	config.set_value("audio", "sfx_volume", value)
	config.save("user://settings.cfg")
	audio_sfx.play()

func _on_bgm_volume_changed(value):
	AudioServer.set_bus_volume_db(3, linear_to_db(value))
	config.set_value("audio", "bgm_volume", value)
	config.save("user://settings.cfg")
	audio_bgm.play()

func _on_fullscreen_toggled(pressed):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if pressed else DisplayServer.WINDOW_MODE_WINDOWED)
	config.set_value("video", "fullscreen", pressed)
	config.save("user://settings.cfg")

func _on_resolution_changed(index):
	if index >= 0 and index < resolutions.size():
		DisplayServer.window_set_size(resolutions[index])
		config.set_value("video", "resolution", resolutions[index])
		config.save("user://settings.cfg")
	else:
		print("Invalid resolution index:", index)

func _on_ui_scale_changed(value):
	get_tree().root.content_scale_factor = value
	config.set_value("video", "ui_scale", value)
	config.save("user://settings.cfg")

func _populate_command_option():
	var keybinds = KeybindManager.get_action_keybinds()
	for key_action in keybinds:
		var hot_key_instantiate = hot_key_scene.instantiate()
		hotkeys.add_child(hot_key_instantiate)
		hot_key_instantiate.set_action(key_action)

func _reset_hotkeys():
	# Ensure the lists have the same length
	var keybinds = KeybindManager.get_action_keybinds()
	var hotkeys_children = hotkeys.get_children()
	if keybinds.size() != hotkeys_children.size():
		print("Error: Mismatched number of keybinds and hotkey display elements.")
		return
	KeybindManager.reset_keybindings()
	
	for i in range(keybinds.size()):
		var key_action = keybinds[i]
		var hot_key_display = hotkeys_children[i]
		hot_key_display.set_action(key_action)
