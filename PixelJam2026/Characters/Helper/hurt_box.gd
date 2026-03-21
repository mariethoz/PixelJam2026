class_name HurtBox extends Area2D

@export var damage: int = 10
@export var emmiter: Node2D

func get_damage():
	emmiter.attack_break()
	return damage
