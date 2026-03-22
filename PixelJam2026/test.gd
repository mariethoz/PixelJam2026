extends Node2D

@export var player: Player
@export var items: Array[ItemData]

@export_file() var title : String

@onready var label = %Label
var time_start

func _ready():
	World.register_player(player)
	for d in items:
		ItemsManager.add_munition(d)
	time_start = Time.get_unix_time_from_system()


func _on_player_end_of_game():
	print("Move to title...")
	if title:
		get_tree().change_scene_to_file(title)
	else:
		print("Game title not assigned!")

func _process(delta):
	var time_now = Time.get_unix_time_from_system()
	var t = time_now - time_start
	label.text = str(t)
