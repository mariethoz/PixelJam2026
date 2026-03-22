class_name Buisson extends Node2D

@export var hp: int = 15
@onready var anim_player = $AnimationPlayer

signal obstacle_destroied

func _on_hit(damage: int):
	print(self.name)
	hp -= damage
	anim_player.play("hit")
	if hp <= 0:
		obstacle_destroied.emit()
		self.queue_free()
