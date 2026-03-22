class_name InventorySlot extends Button

var item_data: ItemData
var have_item = false

@onready var texture_rect = %TextureRect

func is_free():
	return have_item

func set_item(item: ItemData):
	have_item = true
	item_data = item
	texture_rect.texture = item_data.texture

func _on_pressed():
	if have_item:
		have_item = false
		texture_rect.queue_free()
