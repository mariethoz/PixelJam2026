extends CanvasLayer

@export var dialog_text: Array[DialogData]
@export_file var background_texture: String
@export_file var next_scene: String

@onready var dialog = %Dialog
@onready var texture_rect = %TextureRect

func _ready():
	dialog.dialog_data = dialog_text
	texture_rect.texture = load(background_texture)
	dialog.launch_dialog(null)

func dialog_over():
	get_tree().change_scene_to_file(next_scene)
