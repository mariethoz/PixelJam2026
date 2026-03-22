@tool
class_name SpawnPoint extends Marker2D

@export var enemy_scene: PackedScene
@export var parent: Node2D
@export var radius: float = 50

@onready var timer = %Timer

func _ready():
	timer.connect("timeout", _on_timer_timeout)

func get_random_point_in_circle() -> Vector2:
	var t = randf() * TAU
	var r = radius * sqrt(randf())
	return Vector2(r * cos(t), r * sin(t))

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = position + get_random_point_in_circle()
	parent.add_child(enemy)
	enemy.launch_track()

func _draw():
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, radius, Color("ff0000"))
