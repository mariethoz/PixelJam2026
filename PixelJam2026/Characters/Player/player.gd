extends CharacterBody2D

@export var speed = 400

@onready var weapon = $Weapon
@onready var animation_tree = $AnimationTree

var blend_rotation: float = 0

func update_animation():
	if (velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/is_waliking"] = false
		animation_tree["parameters/conditions/is_idle"] = true
	else:
		animation_tree["parameters/conditions/is_waliking"] = true
		animation_tree["parameters/conditions/is_idle"] = false

	animation_tree["parameters/Idle/blend_position"] = blend_rotation
	animation_tree["parameters/Walk/blend_position"] = blend_rotation
	animation_tree["parameters/Dead/blend_position"] = blend_rotation

func get_input():
	var rotation_direction = get_global_mouse_position().angle_to_point(position)
	if abs(rotation_direction) >= PI/2:
		blend_rotation = 1
	else:
		blend_rotation = -1
	update_animation()
	weapon.set_rotation(rotation_direction)
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
