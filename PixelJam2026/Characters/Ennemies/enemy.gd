class_name Monster extends CharacterBody2D

#const PICKUP = preload("item_pickup.tscn")

@export var speed = 200
@export var hp: int = 10
@export var def_knockback_time: float = 2

@export var navigation_agent: NavigationAgent2D
@export var animation_motion: AnimationTree

var knockback: Vector2 = Vector2.ZERO
var knockback_time: float = 0

var is_knock: bool = false
var blend_rotation: float = 0

signal destroied

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func _on_hit(damage: int):
	print("Enemy")
	hp -= damage
	if hp <= 0:
		self.destroied.emit()
		self.queue_free()

func _on_knock(dir: Vector2):
	is_knock = true
	knockback_time = def_knockback_time
	knockback = dir

func attack_break():
	knockback_time = 1

func launch_track():
	navigation_agent.set_target_position(World.get_player_position())

func _on_timer_timeout():
	launch_track()

func update_animation():
	if is_knock:
		animation_motion["parameters/conditions/is_hurt"] = true
		animation_motion["parameters/conditions/is_walking"] = false
		animation_motion["parameters/conditions/is_idle"] = false
	else:
		if (velocity == Vector2.ZERO):
			animation_motion["parameters/conditions/is_hurt"] = false
			animation_motion["parameters/conditions/is_walking"] = false
			animation_motion["parameters/conditions/is_idle"] = true
		else:
			animation_motion["parameters/conditions/is_hurt"] = false
			animation_motion["parameters/conditions/is_walking"] = true
			animation_motion["parameters/conditions/is_idle"] = false

	animation_motion["parameters/Idle/BlendSpace1D/blend_position"] = blend_rotation
	animation_motion["parameters/Walk/BlendSpace1D/blend_position"] = blend_rotation
	animation_motion["parameters/Hurt/BlendSpace1D/blend_position"] = blend_rotation

func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = self.position.direction_to(next_path_position) * speed

	if new_velocity.x > 0:
		blend_rotation = 1
	else:
		blend_rotation = 0

	if knockback_time > 0:
		knockback_time -= delta
		new_velocity = knockback
		if knockback_time <= 0:
			is_knock = false
			knockback = Vector2.ZERO


	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	update_animation()

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
