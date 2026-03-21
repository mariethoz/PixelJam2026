extends CanvasLayer

@onready var resume = %Resume
@onready var restart = %Restart
@onready var menu = %Menu

@export_file var main_menu: String
@export_file var default_restart: String

func _ready():
	self.visible = false


func start_pause():
	print("Pause")
	get_tree().paused = true
	self.visible = true
	self.set_physics_process_internal(true)

func _on_resume_pressed():
	print("Resume")
	self.set_physics_process_internal(false)
	self.visible = false
	get_tree().paused = false

func _on_restart_pressed():
	print("Restart")
	self.set_physics_process_internal(false)
	self.visible = false
	get_tree().paused = false
	var config = ConfigFile.new()
	var load_save_scene
	if config.load("user://settings.cfg") == OK:
		load_save_scene = config.get_value("save","save",default_restart)
	if load_save_scene:
		get_tree().change_scene_to_file(load_save_scene)

func _on_menu_pressed():
	self.set_physics_process_internal(false)
	self.visible = false
	get_tree().paused = false
	print("Menu")
	get_tree().change_scene_to_file(main_menu)
