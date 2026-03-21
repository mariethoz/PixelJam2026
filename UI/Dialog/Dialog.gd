extends CanvasLayer

signal dialog_over 

@export var dialog_data: Array[DialogData]

@export_file var sounds: Array[String]

@onready var texture_rect = %TextureRect
@onready var rich_text_label = %RichTextLabel
@onready var audio_stream_player = %AudioStreamPlayer
@onready var audio_listener = %AudioListener2D

var current_index = 0
var current_speaker

func _ready():
	self.visible = false
	set_process_unhandled_input(false)
	if not dialog_data:
		print("ERROR not dialog asigned")

func launch_dialog(_area):
	get_tree().paused = true
	rich_text_label.clear()
	self.visible = true
	show_next_line()
	audio_listener.make_current()

func show_next_line():
	if current_index < dialog_data.size():
		if dialog_data[current_index].id != current_speaker:
			current_speaker = dialog_data[current_index].id
			rich_text_label.clear()
			var logo = dialog_data[current_index].logo
			
			if FileAccess.file_exists(logo):
				texture_rect.texture = load(logo)
			else:
				print("ERROR NO ICON", logo)
		rich_text_label.append_text(dialog_data[current_index].text)
		rich_text_label.push_paragraph(HORIZONTAL_ALIGNMENT_LEFT)
		current_index += 1
		start_sound(current_index)
		set_process_unhandled_input(true)
	else:
		set_process_unhandled_input(false)
		get_tree().paused = false
		dialog_over.emit()
		audio_listener.clear_current()
		self.queue_free()

func start_sound(i:int):
	if i < sounds.size() and sounds.size() > 1:
		audio_stream_player.stop()
		audio_stream_player.stream = load(sounds[i])
		audio_stream_player.play()
	elif sounds.size() > 1:
		audio_stream_player.stop()
		audio_stream_player.stream = load(sounds[0])
		audio_stream_player.play()

func _unhandled_input(event):
	if Input.is_action_just_pressed("jump"):
		show_next_line()
