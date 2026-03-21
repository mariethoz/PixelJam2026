class_name Player extends CharacterBody2D

@export var speed = 400
@export var hp = 10


@export var angle_block = 10

@onready var weapon = %Weapon
@onready var hurt_box = %HurtBox

@onready var animation_motion = %AnimationMotion
@onready var animation_attack = %AnimationAttack

var knockback: Vector2 = Vector2.ZERO
var knockback_time: float = 0

var blend_rotation: float = 0
var is_attacking = false

func hit(damage: int):
	hp -= damage

func knock(dir: Vector2):
	knockback_time = 1
	knockback = dir

func attack_break():
	knockback_time = 1

func update_animation():
	if hp <= 0:
		animation_motion["parameters/conditions/is_dead"] = true
		animation_motion["parameters/conditions/is_walking"] = false
		animation_motion["parameters/conditions/is_idle"] = false
	else:
		animation_attack["parameters/conditions/is_attacking"] = is_attacking
		if (velocity == Vector2.ZERO):
			animation_motion["parameters/conditions/is_walking"] = false
			animation_motion["parameters/conditions/is_idle"] = true
		else:
			animation_motion["parameters/conditions/is_walking"] = true
			animation_motion["parameters/conditions/is_idle"] = false

	animation_motion["parameters/Idle/blend_position"] = blend_rotation
	animation_motion["parameters/Walk/blend_position"] = blend_rotation
	animation_motion["parameters/Dead/blend_position"] = blend_rotation

func get_input():
	var rotation_direction = get_global_mouse_position().angle_to_point(position)
	if abs(rotation_direction) >= PI/2:
		blend_rotation = 1
	else:
		blend_rotation = -1

	hurt_box.set_rotation(rotation_direction)
	if rotation_direction <= -PI/angle_block and rotation_direction >= -(angle_block-1)*PI/angle_block:
		if rotation_direction < -PI/2:
			rotation_direction = -(angle_block-1)*PI/angle_block
		else:
			rotation_direction = -PI/angle_block

	weapon.set_rotation(rotation_direction)

	if Input.is_action_just_pressed("click"):
		is_attacking = true

	if Input.is_action_just_released("click"):
		is_attacking = false

	update_animation()

	return Input.get_vector("left", "right", "up", "down") * speed


func _physics_process(delta):
	var new_velocity = get_input()
	
	if knockback_time > 0:
		knockback_time -= delta
		new_velocity = knockback
		if knockback_time <= 0:
			knockback = Vector2.ZERO
	velocity = new_velocity
	move_and_slide()
