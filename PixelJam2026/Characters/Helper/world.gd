class_name GameManager extends Node

var rng = RandomNumberGenerator.new()

const STRENGHT_MIN = 1
const STRENGHT_MAX = 10

const HP_MIN = 10
const HP_MAX = 100

const SPEED_MIN = 50
const SPEED_MAX = 800

var player: Player = null

func register_player(p: Player):
	player = p

func get_player_position():
	if player:
		return player.get_global_position()
	else:
		return Vector2.ZERO

func spawn_monster(position: Vector2):
	var strenghtd = rng.randi_range(STRENGHT_MIN, STRENGHT_MAX)
	var speed = rng.randi_range(SPEED_MIN,SPEED_MAX)
	var hp = rng.randi_range(HP_MIN,HP_MAX)
	#var monster = ...
	#world.add_monster(monster)
