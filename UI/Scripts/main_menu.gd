class_name MainMenu extends CanvasLayer

@export_category("Buttons for Main Menu")
@export var new_button: Button
@export var load_button: Button
@export var settings_button: Button
@export var exit_button: Button

@export_category("Packed Scene")
@export_file() var game_scene: String
@export_file() var load_save_scene: String
@export_file() var settings_scene: String

@onready var menu_window = $MenuWindow

func _ready():
	$Music.play()
	# Connect button signals (Make sure button names match)
	if new_button:
		new_button.connect("pressed", _on_new_game_pressed)
	else: 
		print("New Game button not assigned!")
	if load_button:
		load_button.connect("pressed", _on_load_game_pressed)
	else: 
		print("Load button not assigned!")
	if settings_button:
		settings_button.connect("pressed", _on_settings_pressed)
	else: 
		print("Settings button not assigned!")
	if exit_button:
		exit_button.connect("pressed", _on_exit_pressed)
	else: 
		print("Exit button not assigned!")
	# Check that scenes are assigned
	if not game_scene:
		print("Game scene not assigned!")
	if not load_save_scene:
		print("Load/Save scene not assigned!")
	if not settings_scene:
		print("Settings scene not assigned!")
	# Update the settings
	_update_settings()


# Button Functions
func _on_new_game_pressed():
	print("Starting a new game...")
	if game_scene:
		get_tree().change_scene_to_file(game_scene)
	else:
		print("Game scene not assigned!")

func _on_load_game_pressed():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		load_save_scene = config.get_value("save","save",load_save_scene)
	if load_save_scene:
		get_tree().change_scene_to_file(load_save_scene)
	else:
		print("Load/Save scene not assigned!")

func _on_settings_pressed():
	if settings_scene:
		var settings_menu = load(settings_scene).instantiate()
		menu_window.open(settings_menu)  # Opens settings as overlay
	else:
		print("Settings scene not assigned!")

func _on_exit_pressed():
	get_tree().quit()  # Closes the game

func _update_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var master_volume = config.get_value("audio", "master_volume", 1.0)
		var music_volume = config.get_value("audio", "music_volume", 1.0)
		var sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
		var bgm_volume = config.get_value("audio", "bgm_volume", 1.0)
		
		var fullscreen = config.get_value("video", "fullscreen", false)
		var resolution = config.get_value("video", "resolution", get_viewport().size)
		var ui_scale = config.get_value("video", "ui_scale", 1.0)

		AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
		AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))
		AudioServer.set_bus_volume_db(2, linear_to_db(sfx_volume))
		AudioServer.set_bus_volume_db(3, linear_to_db(bgm_volume))

		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
		get_tree().root.content_scale_factor = ui_scale
		
		DisplayServer.window_set_size(resolution)
		
	else:
		print("No settings file found, using defaults.")

func _process(_delta):
	if Input.is_action_just_pressed("move_left"):
		print("Move left pressed")
	if Input.is_action_just_pressed("move_right"):
		print("Move right pressed")
