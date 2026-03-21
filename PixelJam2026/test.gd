extends Node2D

@export var player: Player

func _ready():
	World.register_player(player)
