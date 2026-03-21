class_name Arbre extends Node2D

@export var hp: int = 30
@onready var arbre = $Arbre
@onready var anim_player = $AnimationPlayer
@onready var branch = $Baton
@onready var branch_drop = $Baton/AnimationPlayer

func hit(damage: int):
	if arbre.visible:
		print(self.name)
		hp -= damage
		anim_player.play("hit")
		if hp <= 0:
			arbre.visible = false	
			on_death()
			#self.queue_free()
	elif branch.visible:
		print("Fetching branch")
		save_to_inventory()
		self.queue_free()
		
func save_to_inventory():
	print("saving to inventory")
		
func on_death():
	print("kikou")
	branch.visible = true
	branch_drop.play("branch_drop")

func knock(dir: Vector2):
	pass
	
# Called when the node enters the scene tree for the first time.

func _ready():
	arbre.visible = true
	branch.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
