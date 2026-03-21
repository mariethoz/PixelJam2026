class_name Monster extends CharacterBody2D

@export var speed = 200
@export var hp: int = 10
@export var def_knockback_time: float = 2

@export var navigation_agent: NavigationAgent2D

var knockback: Vector2 = Vector2.ZERO
var knockback_time: float = 0


func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func hit(damage: int):
	hp -= damage
	if hp <= 0:
		self.queue_free()

func knock(dir: Vector2):
	knockback_time = def_knockback_time
	knockback = dir

func attack_break():
	knockback_time = 1

func _on_timer_timeout():
	navigation_agent.set_target_position(World.get_player_position())

func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = self.position.direction_to(next_path_position) * speed

	if knockback_time > 0:
		knockback_time -= delta
		new_velocity = knockback
		if knockback_time <= 0:
			knockback = Vector2.ZERO

	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
