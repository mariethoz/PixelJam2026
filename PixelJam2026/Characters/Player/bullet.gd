class_name Bullet extends CharacterBody2D

@onready var hurt_box = %HurtBox

var speed = 200

func set_damage(dmg: int):
	hurt_box.damage = dmg

func attack_break():
	await get_tree().process_frame
	queue_free()

func _process(delta):
	velocity = Vector2.LEFT.rotated(rotation) * speed
	move_and_slide()


func _on_timer_timeout():
	hurt_box.monitorable = false
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	queue_free()
