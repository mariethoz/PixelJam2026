class_name UI extends CanvasLayer

@export var init_inventory: InventoryData

@onready var base_menu_screen = %baseMenuScreen
@onready var base_menu_open = %baseMenuOpen

@onready var inventory_slot_1 = %InventorySlot1
@onready var inventory_slot_2 = %InventorySlot2
@onready var inventory_slot_3 = %InventorySlot3
@onready var inventory_slot_4 = %InventorySlot4
@onready var inventory_slot_5 = %InventorySlot5
@onready var inventory_slot_6 = %InventorySlot6
@onready var inventory_slot_7 = %InventorySlot7
@onready var inventory_slot_8 = %InventorySlot8

@onready var hide_menu_button = %hideMenuButton
@onready var display_menu_button = %displayMenuButton

var inventory_slots = []

func _ready():
	inventory_slots.append(inventory_slot_1)
	inventory_slots.append(inventory_slot_2)
	inventory_slots.append(inventory_slot_3)
	inventory_slots.append(inventory_slot_4)
	inventory_slots.append(inventory_slot_5)
	inventory_slots.append(inventory_slot_6)
	inventory_slots.append(inventory_slot_7)
	inventory_slots.append(inventory_slot_8)
	for i in init_inventory.slots:
		update_inventory(i)
	
	hide_menu_button.connect("pressed", _on_toggle_menu_button_pressed)
	display_menu_button.connect("pressed", _on_toggle_menu_button_pressed)

func toggle_visblitity(object):
	object.visible = !object.visible

func _on_toggle_menu_button_pressed():
	toggle_visblitity(base_menu_screen)
	toggle_visblitity(base_menu_open)


func update_inventory(item: ItemData) -> bool:
	for d in inventory_slots:
		if not d.is_free():
			d.set_item(item)
			return true
	return false
