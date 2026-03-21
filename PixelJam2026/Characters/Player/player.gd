extends CharacterBody2D

@export var speed = 400
@export var hp = 10


@export var angle_block = 10

@onready var weapon = %Weapon
@onready var hurt_box = %HurtBox

@onready var animation_motion = %AnimationMotion
@onready var animation_attack = %AnimationAttack


var blend_rotation: float = 0
var is_attacking = false

func hit(damage: int):
	hp -= damage

func update_animation():
	if hp <= 0:
		animation_motion["parameters/condition/is_dead"] = true
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
	
#@onready var anim = $AnimatedBody2D
	#
#func update_animation(direction):
	#if direction == Vector2.ZERO:
		#anim.play("idle")
	#else:
		#anim.play("walk")
#
		#if direction.x != 0:
			#anim.flip_h = direction.x > 0
			#weapon.flip_h = direction.x > 0
				

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
	
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

	if Input.is_action_just_pressed("click"):
		#attack()
		is_attacking = true

	if Input.is_action_just_released("click"):
		is_attacking = false

	update_animation()
	
	return input_direction

#func _process(delta):
	#weapon.look_at(get_global_mouse_position())
#
func attack():
	if is_attacking:
		return
	
	is_attacking = true
	
	var original_rotation = weapon.rotation
	var attack_rotation = original_rotation + 1.5 * blend_rotation # tweak this

	# quick swing forward
	var tween = create_tween()
	tween.tween_property(weapon, "rotation", attack_rotation, 0.1)
	tween.tween_property(weapon, "rotation", original_rotation, 0.1)

	tween.finished.connect(func():
		is_attacking = false
	)
	
#func _input(event):
	#if event.is_action_pressed("click"):
		#attack()
		
#func _physics_process(delta):
	#get_input()
	#move_and_slide()

func _physics_process(delta):
	#var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = get_input()
	velocity = direction * speed
	move_and_slide()

	#update_animation(direction)	
