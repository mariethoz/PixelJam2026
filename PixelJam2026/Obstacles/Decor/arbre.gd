class_name Arbre extends Node2D

@export var hp: int = 30
@export var item: ItemData

@onready var anim_player = %AnimationPlayer

signal obstacle_destroied

func _ready():
	self.visible = true
	

func _on_hit(damage: int):
	print("Arbre")
	if self.visible:
		hp -= damage
		anim_player.play("hit")
		if hp <= 0:
			self.visible = false	
			on_death()
			await get_tree().process_frame
			self.queue_free()

func on_death():
	obstacle_destroied.emit()
	ItemsManager.add_munition(item)
