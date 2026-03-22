extends Node2D

@export var player: Player
@export var items: Array[ItemData]

func _ready():
	World.register_player(player)
	for d in items:
		ItemsManager.add_munition(d)
