class_name Caillou extends StaticBody2D

@export var hp: int = 10
@onready var anim_player = %AnimationPlayer

signal obstacle_destroied

func dipshitmotherfucker():
	print("dipshitmotherfucker")

func _on_hit(damage: int):
	print(self.name)
	hp -= damage
	anim_player.play("hit")
	if hp <= 0:
		obstacle_destroied.emit()
		self.queue_free()
