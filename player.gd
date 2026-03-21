class_name Player extends CharacterBody2D

const DEFAULT_SPEED = 210.0
const DEFAULT_JUMP_VELOCITY = -200.0
const BOOSTED_JUMP_VELOCITY = -400.0
const ICE_JUMP_VELOCITY = -100.0

@export_category("Scene")
@export_file var game_over: String = ""
@export_file var next_level: String = ""

@export_category("Sound")
@export_file var steps_sound: Array[String] = []
@export_file var jump_sound:String = ""
@export_file var water_death:String = ""
@export_file var fire:String = ""
@export_file var ice:String = ""
@export_file var wind:String = ""

@export_category("Variable")
@export var player_halo: bool = false
@export var scale_factor: float = 6
@export var power_to_get:String = ""


@onready var audio_listener = %AudioListener2D
@onready var audio_stream_player = %AudioStreamPlayer2D
@onready var animated_sprite = %AnimatedSprite2D
@onready var directional_light = %DirectionalLight2D
@onready var player_light = %PlayerLight
@onready var shadows = %Shadows
@onready var cam = %Cam
@onready var particle_back_fire = %Particle_Back_Fire
@onready var particle_back_ice = %Particle_Back_Ice
@onready var particle_back_wind = %Particle_Back_Wind
@onready var particle_front_wind = %Particle_Front_Wind
@onready var particle_front_ice = %Particle_Front_Ice
@onready var particle_front_fire = %Particle_Front_Fire
@onready var glou_glou_timer = %GlouGlouTimer
@onready var glou_glou_progress = %GlouGlouProgress
@onready var canvas_layer = %PauseMenu

var speed = DEFAULT_SPEED
var jump_velocity = DEFAULT_JUMP_VELOCITY

func _ready():
	audio_listener.make_current()
	audio_stream_player.play()
	var config = ConfigFile.new()
	if player_halo:
		player_light.enabled = true
		shadows.enabled = true
		directional_light.enabled = true
	if config.load("user://settings.cfg") == OK:
		var screen_size = config.get_value("video", "default_resolution", get_viewport().size)
		var server_size = get_viewport().size
		cam.zoom = Vector2i(scale_factor * server_size.x/screen_size.x,scale_factor * server_size.y/screen_size.y)

func _play_sound(sound: String):
	var playback = audio_stream_player.get_stream_playback();
	playback.play_stream(load(sound), 0,
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")), 1, 0, "SFX")

func _play_sound_random(steps: Array[String]):
	var rng = RandomNumberGenerator.new()
	_play_sound(steps[rng.randi_range(0,steps.size() - 1)])

func _physics_process(delta: float) -> void:
	animated_sprite.play()
	particle_back_wind.play()
	particle_front_wind.play()
	particle_back_ice.play()
	particle_front_ice.play()
	particle_back_fire.play()
	particle_front_fire.play()
	animated_sprite.flip_v = false
	glou_glou_progress.value = glou_glou_timer.time_left

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_play_sound(jump_sound)
		velocity.y = jump_velocity
		
	# Handle pause
	if Input.is_action_just_pressed("pause"):
		canvas_layer.start_pause()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if velocity.y != 0:
		animated_sprite.animation = "jump"
		animated_sprite.flip_h = velocity.x < 0
	else:
		if velocity.x != 0:
			animated_sprite.animation = "walk"
			animated_sprite.flip_h = velocity.x < 0
		else:
			animated_sprite.animation = "idle"
		
	global_position.x = clamp(global_position.x, 10,9999999)
	
	if Input.is_action_just_pressed("ice") and has_ice_enchantment:
		if _fire_activated:
			activate_fire_enchantment()
		if _wind_activated:
			activate_wind_enchantment()
		activate_ice_enchantment()
	
	if Input.is_action_just_pressed("wind") and has_wind_enchantment:
		if _fire_activated:
			activate_fire_enchantment()
		if _ice_activated:
			activate_ice_enchantment()
		activate_wind_enchantment()
		
	if Input.is_action_just_pressed("fire") and has_fire_enchantment:
		if _ice_activated:
			activate_ice_enchantment()
		if _wind_activated:
			activate_wind_enchantment()
		activate_fire_enchantment()

	move_and_slide()

func _on_dedly_body_entered(_body):
	print("AAAAAAAAAïïïïïïïïïïeeeeeeeee")
	if game_over != "":
		get_tree().change_scene_to_file(game_over)

func _on_animated_sprite_2d_animation_changed():
	if animated_sprite.animation == "walk" and not steps_sound.is_empty():
		_play_sound_random(steps_sound)

#Fire
@export var has_fire_enchantment = false
var _fire_activated = false
func activate_fire_enchantment():
	if !_fire_activated:
		print("Fire enchantment activated")
		self.set_collision_layer_value(6,true)
		_play_sound(fire)
		if player_halo:
			player_light.set_texture_scale(1.0)
			shadows.set_texture_scale(1.5)
			player_light.enabled = true
			shadows.enabled = true
			directional_light.enabled = true
		particle_back_fire.visible = true
		particle_front_fire.visible = true
		_fire_activated = true
	else:
		print("Fire enchantment deactivated")
		self.set_collision_layer_value(6,false)
		if player_halo:
			player_light.set_texture_scale(0.5)
			shadows.set_texture_scale(1.0)
			player_light.enabled = true
			shadows.enabled = true
			directional_light.enabled = true
		particle_back_fire.visible = false
		particle_front_fire.visible = false
		_fire_activated = false

#Ice
@export var has_ice_enchantment = false
var _ice_activated = false
func activate_ice_enchantment():
	if get_collision_mask_value(2) == false:
		print("Ice enchantment activated")
		_play_sound(ice)
		_ice_activated = true
		particle_back_ice.visible = true
		particle_front_ice.visible = true
		set_collision_mask_value(2, true)
		jump_velocity = ICE_JUMP_VELOCITY
	else:
		print("Ice enchantment deactivated")
		_ice_activated = false
		particle_back_ice.visible = false
		particle_front_ice.visible = false
		set_collision_mask_value(2, false)
		jump_velocity = DEFAULT_JUMP_VELOCITY

#Wind
@export var has_wind_enchantment = false
var _wind_activated = false
func activate_wind_enchantment():
	if jump_velocity == DEFAULT_JUMP_VELOCITY:
		print("Wind enchantment activated")
		_play_sound(wind)
		_wind_activated = true
		particle_back_wind.visible = true
		particle_front_wind.visible = true
		jump_velocity = BOOSTED_JUMP_VELOCITY
	else:
		print("Wind enchantment deactivated")
		_wind_activated = false
		particle_back_wind.visible = false
		particle_front_wind.visible = false
		jump_velocity = DEFAULT_JUMP_VELOCITY


func _on_water_body_entered(_body):
	print("WATER GLU GLU GLupe")
	glou_glou_timer.start()
	glou_glou_progress.visible=true

func _on_glou_glou_timer_timeout() -> void:
	print("AAAAAAAAAïïïïïïïïïïeeeeeeeee")
	_play_sound(water_death)
	await get_tree().create_timer(1)
	if game_over != "":
		get_tree().change_scene_to_file(game_over)

func _on_water_body_exited(_body: Node2D) -> void:
	glou_glou_timer.stop()
	glou_glou_progress.visible=false
	glou_glou_timer.wait_time = 5

func _on_next_level_area_entered(_area: Area2D) -> void:
	print("Next Level")
	if next_level != "":
		get_tree().change_scene_to_file(next_level)

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "walk" and animated_sprite.frame in [0,3]:
		_play_sound_random(steps_sound)

func _on_get_power_area_entered(area: Area2D) -> void:
	$Areas/GetPower.set_collision_mask_value(32, false)
	$Areas/GetPower.set_collision_layer_value(32, false)
	match power_to_get:
		"ice": 
			if(!has_ice_enchantment):
				has_ice_enchantment = true
				activate_ice_enchantment()
		"fire": 
			if(!has_fire_enchantment):
				has_fire_enchantment = true
				activate_fire_enchantment()
		"wind": 
			if(!has_wind_enchantment):
				has_wind_enchantment = true
				activate_wind_enchantment()
