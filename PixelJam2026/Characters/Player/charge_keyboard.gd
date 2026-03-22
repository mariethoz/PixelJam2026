class_name ChargeKeyboard
extends CanvasLayer

signal keyboard_charged

@export var key_pair: Array[KeyPairs]
@export var player: Player

@onready var textures = [
	%TextureRect1,
	%TextureRect2,
	%TextureRect3,
	%TextureRect4,
	%TextureRect5
]

var is_charging: bool = false
var sequence: Array[KeyPairs] = []
var progress := 0   # index de la prochaine touche attendue

func _ready():
	visible = false
	set_process_unhandled_input(true)
	set_process_input(false)


func charge_keyboard():
	is_charging = true
	sequence.clear()
	progress = 0

	# Génère la séquence correcte
	for i in range(5):
		sequence.append(key_pair.pick_random())

	# Affiche les textures neutres
	for i in range(5):
		textures[i].texture = sequence[i].texture_neutre

	visible = true


func _unhandled_input(event):
	if not is_charging:
		return

	if not (event is InputEventKey and event.pressed):
		return

	var key = OS.get_keycode_string(event.keycode)
	var expected := sequence[progress]

	# Vérifie si la touche est correcte
	if key == expected.keycode:
		textures[progress].texture = expected.texture_pressed
		progress += 1
	else:
		# Mauvaise touche → reset ou annulation
		return

	# Si toute la séquence est validée
	if progress >= sequence.size():
		print("Charged")
		is_charging = false
		keyboard_charged.emit()
		visible = false
