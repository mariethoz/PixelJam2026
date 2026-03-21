class_name Slime extends CharacterBody2D

@export var cave: bool = false

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var point_light: PointLight2D = %PointLight2D
@onready var damage_attack = %Damage_attack

var speed = 50
var direction = 1

func _ready():
	animation_player.play("idle")  # Start with an idle animation
	point_light.enabled = cave
	damage_attack.monitorable = false
	

func _process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = direction * speed
	sprite_2d.flip_h = velocity.x < 0
	move_and_slide()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'idle':
		direction = randf() - 0.5
		animation_player.play("move")
	if anim_name == 'move' and randf() > 0.75:
		direction = 0
		animation_player.play("attack")
	else:
		direction = randf() - 0.5
		animation_player.play("move")
	if anim_name == "attack":
		direction = 0
		animation_player.play("idle")


func _on_damage_area_entered(area):
	print("slime")
	pass # Replace with function body.


func _on_damage_attack_area_entered(area):
	print("slime")
	pass # Replace with function body.
