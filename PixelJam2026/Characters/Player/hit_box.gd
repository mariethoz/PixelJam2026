class_name HitBox extends Area2D


@export var receiver: Node2D

func _on_body_entered(body):
	if body is HurtBox:
		receiver.hit(body.get_damage())
