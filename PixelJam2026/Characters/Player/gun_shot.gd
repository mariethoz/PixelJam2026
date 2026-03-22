class_name GunShot extends Marker2D

@export var bullet_scene: PackedScene
@export var hurt_box: HurtBox
@export var player: Player


func shot_with_gun():
	if ItemsManager.use_munition():
		var bullet = bullet_scene.instantiate()
		bullet.position = self.get_global_position()
		bullet.rotation = hurt_box.rotation
		player.get_parent().add_child(bullet)
