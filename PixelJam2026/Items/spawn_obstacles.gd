class_name SpawnObstacles extends Marker2D

@export var max_obstacles: int = 10
@export var parent: Node2D
@export var radius: float = 50

@export var obstacles: Array[ObstacleProba]

@onready var timer = %Timer

var nb_obstacles: int = 0

var rng = RandomNumberGenerator.new()

func _ready():
	timer.connect("timeout", _on_timer_timeout)


func get_random_point_in_circle() -> Vector2:
	var t = randf() * TAU
	var r = radius * sqrt(randf())
	return Vector2(r * cos(t), r * sin(t))

func _on_obstacle_destroied():
	nb_obstacles -= 1

func _on_timer_timeout():
	if nb_obstacles >= max_obstacles:
		return

	var ob = obstacles[rng.randi_range(0,obstacles.size()-1)]
	if ob.probability > rng.randf_range(0,100):
		var obstacle = ob.obstacle.instantiate()
		nb_obstacles += 1
		obstacle.position = position + get_random_point_in_circle()
		print(obstacle.name)
		obstacle.obstacle_destroied.connect(_on_obstacle_destroied)
		parent.add_child(obstacle)

func _draw():
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, radius, Color("00ff00"))
