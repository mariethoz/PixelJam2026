class_name ActionKey extends Resource

@export var name: String
@export var tag: String
@export var event: InputEvent : set = set_event

var default: InputEvent

func set_event(value: InputEvent):
	event = value
	if not default:
		default = value
