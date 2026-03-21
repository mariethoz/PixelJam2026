extends Node2D

@export_file var next_level

@onready var gate: AnimatedSprite2D = $Gate/animated_gate

func _on_gate_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		gate.play("Opening")

func _on_gate_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player":
		gate.play("Closing")

@onready var anim_player: AnimationPlayer = $Fade_to_black

func _on_animated_gate_animation_finished() -> void:
	if gate.animation == "Opening":
		anim_player.play("Fade_to_black")
		await anim_player.animation_finished
		get_tree().change_scene_to_file(next_level)
