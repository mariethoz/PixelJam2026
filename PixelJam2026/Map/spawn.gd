extends Node2D


@export var monsters_spawn: Array[SpawnPoint]

func _on_timer_timeout():
	for s in monsters_spawn:
		s.reduce_wait_time(1)
