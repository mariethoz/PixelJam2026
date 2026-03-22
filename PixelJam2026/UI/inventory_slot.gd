class_name InventorySlot extends TextureRect

func set_item(item: ItemData):
	texture = item.texture

func clear_slot():
	texture = null
