class_name Caillou extends Node2D

@export var hp: int = 10
@onready var anim_player = $AnimationPlayer

func dipshitmotherfucker():
	print("dipshitmotherfucker")

func hit(damage: int):
	print(self.name)
	hp -= damage
	anim_player.play("hit")
	if hp <= 0:
		self.queue_free()

func knock(dir: Vector2):
	pass
	
# Called when the node enters the scene tree for the first time.

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
