class_name HitBox extends Area2D

signal hit(dmg: int)
signal knock(dir: Vector2)

func _ready():
	monitorable = false
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if area is HurtBox:
		var damage = area.get_damage()
		var knock_dir = (self.get_global_position()-area.get_global_position()).normalized()
		print(damage,knock_dir)
		hit.emit(damage)
		knock.emit(knock_dir * damage * 50)
