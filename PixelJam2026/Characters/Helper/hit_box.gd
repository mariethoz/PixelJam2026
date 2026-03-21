class_name HitBox extends Area2D


@export var receiver: Node2D

func _ready():
	monitorable = false
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if area is HurtBox:
		var damage = area.get_damage()
		var knock = (self.get_global_position()-area.get_global_position()).normalized()
		receiver.hit(damage)
		receiver.knock(knock * damage * 50)
