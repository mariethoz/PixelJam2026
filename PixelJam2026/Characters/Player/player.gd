class_name Player extends CharacterBody2D

@export var speed = 400
@export var hp = 10


@export var angle_block = 10

@onready var weapon = %Weapon
@onready var gun_shot = %GunShot
@onready var sword_impact = %SwordImpact
@onready var body = $Body

@onready var animation_motion = %AnimationMotion
@onready var animation_attack = %AnimationAttack
@onready var animation_die = %AnimatedSpriteDie2D
@onready var animation_hit = %AnimatedSpriteHit2D
@onready var charge_keyboard = %ChargeKeyboard

var knockback: Vector2 = Vector2.ZERO
var knockback_time: float = 0

var blend_rotation: float = 0
var is_attacking = false
var is_charging = false
var have_sword = true
var have_gun = false
var have_keyboard = false
var dead = false

func _ready():
	animation_die.visible = false
	animation_hit.visible = false

func _on_hit(damage: int):
	hp -= damage
	animation_hit.visible = true
	body.visible = false
	animation_hit.play("hit")
	if not animation_hit.animation_finished.is_connected(_on_hit_finished):
		animation_hit.animation_finished.connect(_on_hit_finished)
	print("HP: " + str(hp))
	if hp <= 0:
		dead = true
		velocity = Vector2.ZERO
		body.visible = false
		weapon.visible = false
		animation_die.visible = true
		animation_die.play("die")
		if not animation_die.animation_finished.is_connected(_on_die_finished):
			animation_die.animation_finished.connect(_on_die_finished)
			
func _on_hit_finished():
	animation_hit.visible = false
	body.visible = true
	
func _on_die_finished():
	body.visible = false
	end_of_game()

func end_of_game():
	get_tree().paused = true
	get_tree().change_scene_to_file("res://PixelJam2026/UI/title.tscn")
	print("End of game")

func _on_knock(dir: Vector2):
	if dead:
		knockback = Vector2.ZERO
	else:
		knockback_time = 1
		knockback = dir

func _on_charge_keyboard_keyboard_charged():
	is_charging = false

func attack_break():
	knockback_time = 0.3

func update_animation():
	if hp <= 0:
		animation_motion["parameters/conditions/is_dead"] = true
		animation_motion["parameters/conditions/is_walking"] = false
		animation_motion["parameters/conditions/is_idle"] = false
	else:
		animation_attack["parameters/conditions/is_attacking"] = is_attacking
		animation_attack["parameters/conditions/is_charged"] = not is_charging
		if (velocity == Vector2.ZERO):
			animation_motion["parameters/conditions/is_walking"] = false
			animation_motion["parameters/conditions/is_idle"] = true
		else:
			animation_motion["parameters/conditions/is_walking"] = true
			animation_motion["parameters/conditions/is_idle"] = false
	
	animation_attack["parameters/conditions/have_sword"] = have_sword
	animation_attack["parameters/conditions/have_gun"] = have_gun
	animation_attack["parameters/conditions/have_keyboard"] = have_keyboard
	
	animation_motion["parameters/Idle/blend_position"] = blend_rotation
	animation_motion["parameters/Walk/blend_position"] = blend_rotation
	animation_motion["parameters/Dead/blend_position"] = blend_rotation
	animation_die.flip_h = blend_rotation == 1
	animation_hit.flip_h = blend_rotation == 1

func get_input():
	var rotation_direction = get_global_mouse_position().angle_to_point(position)
	if abs(rotation_direction) >= PI/2:
		blend_rotation = 1
	else:
		blend_rotation = -1

	sword_impact.set_rotation(rotation_direction)
	gun_shot.set_rotation(rotation_direction)
	if rotation_direction <= -PI/angle_block and rotation_direction >= -(angle_block-1)*PI/angle_block:
		if rotation_direction < -PI/2:
			rotation_direction = -(angle_block-1)*PI/angle_block
		else:
			rotation_direction = -PI/angle_block

	weapon.set_rotation(rotation_direction)

	if Input.is_action_just_pressed("switch_arm"):
		if have_keyboard:
			have_sword = true
			have_keyboard = false
		elif have_gun:
			have_keyboard = true
			have_gun = false
		elif have_sword:
			have_gun = true
			have_sword = false

	if Input.is_action_just_pressed("click"):
		if have_keyboard and not is_charging:
			charge_keyboard.charge_keyboard()
			is_charging = true
		is_attacking = true

	if Input.is_action_just_released("click"):
		is_attacking = false

	if is_charging:
		return Vector2.ZERO
	return Input.get_vector("left", "right", "up", "down") * speed


func _physics_process(delta):
	var new_velocity = get_input()
	
	if knockback_time > 0:
		knockback_time -= delta
		new_velocity = knockback
		if knockback_time <= 0:
			knockback = Vector2.ZERO
	velocity = new_velocity
	
	if !dead:
		update_animation()
		move_and_slide()
