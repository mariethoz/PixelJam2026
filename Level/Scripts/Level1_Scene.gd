extends Node

@export var debug_mode = false

@onready var start_pos = $Level/StartPos
@onready var player = $Player
@onready var music = $Music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position = start_pos.position
	music.play()
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		config.set_value("save","save",get_tree().current_scene.scene_file_path)
		config.save("user://settings.cfg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset") and debug_mode:
		player.position = start_pos.position
