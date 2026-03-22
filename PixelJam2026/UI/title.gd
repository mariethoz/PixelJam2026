extends CanvasLayer


@export_file() var game_scene: String = "res://PixelJam2026/Map/Level0.tscn"

@onready var start = %Start
@onready var exit = %Exit

func _ready():
	start.pressed.connect(_on_start_pressed)
	exit.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	print("Starting a new game...")
	if game_scene:
		get_tree().change_scene_to_file(game_scene)
	else:
		print("Game scene not assigned!")

func _on_exit_pressed():
	get_tree().quit()  # Closes the game
