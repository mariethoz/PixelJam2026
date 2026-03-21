extends PointLight2D

@export var light_on: bool = false
@onready var sprite_2d = %Sprite2D
@onready var shadow = %Shadow

func _ready():
	self.enabled = light_on
	shadow.enabled = light_on
	if light_on:
		sprite_2d.play("light_on")
	else:
		sprite_2d.play("light_off")

func _on_area_2d_body_entered(body):
	if body is Player and not light_on:
		light_on = true
		shadow.enabled = light_on
		self.enabled = true
		sprite_2d.play("light_on")
