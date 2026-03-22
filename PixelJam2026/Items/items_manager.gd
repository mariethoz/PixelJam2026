extends Node

var inventory: Array[ItemData]
var slots: Array[InventorySlot]
var max_size = 8

func update_inventory():
	for i in range(max_size):
		if inventory.size() > i :
			slots[i].set_item(inventory[i])
		else:
			slots[i].clear_slot()

func register_slots(ui_slots):
	slots = ui_slots
	update_inventory()

func add_munition(mun: ItemData):
	if inventory.size() < max_size:
		inventory.append(mun)
		update_inventory()

func use_munition() -> bool:
	if inventory.size() > 0:
		inventory.pop_back()
		update_inventory()
		return true
	return false
