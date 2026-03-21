extends CanvasLayer

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	anim_player.play("Fade_in")
