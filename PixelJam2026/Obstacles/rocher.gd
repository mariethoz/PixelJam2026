class_name Rocher extends StaticBody2D

@export var hp: int = 30
@export var item: ItemData

@onready var anim_player = %AnimationPlayer
@onready var rocher = $Rocher
@onready var spell = $Spell
@onready var spell_animate = $Spell/AnimationPlayer

signal obstacle_destroied

#func _on_hit(damage: int):
	#print(self.name)
	#print(item)
	#hp -= damage
	#anim_player.play("hit")
	#if hp <= 0:
		#obstacle_destroied.emit()
		#ItemsManager.add_munition(item)
		#self.queue_free()

func _on_hit(damage: int):
	if rocher.visible:
		hp -= damage
		print("Hitting " + self.name + " | HP: " + str(hp))
		anim_player.play("hit")
		if hp <= 0:
			rocher.visible = false
			print("A spell appears")
			spell.visible = true
			spell_animate.play("spell_animate")
	elif spell.visible:
		print("Fetching spell")
		on_death()
		await get_tree().process_frame
		self.queue_free()
	
func on_death():
	obstacle_destroied.emit()
	#ItemsManager.add_munition(item)
	
func knock(dir: Vector2):
	pass
	
func _ready():
	spell.visible = false
