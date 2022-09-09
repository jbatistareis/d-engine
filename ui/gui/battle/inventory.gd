extends MarginContainer

var character : Character


func _ready() -> void:
	Signals.connect("battleInventoryShow", self, "showWindow")
	Signals.connect("guiCancel", self, "hide")


func showWindow(character : Character) -> void:
	self.character = character
	
	if character.inventory.items.empty():
		# TODO show message
		print('Your inventory is empty')
	
	for item in character.inventory.items:
		var itemName = item.name.substr(0, 14)
		for i in range(14 - itemName.length()):
			itemName += ' '
		
		$ItemList.add_item(itemName)
	
	visible = true
	$ItemList.grab_focus()
	if !$ItemList.items.empty():
		$ItemList.select(0)


func hide() -> void:
	if visible:
		visible = false
		Signals.emit_signal("battleShowCharacterMoves", character)



func _on_ItemList_item_activated(index):
	var itemMove = ItemMove.new(character.inventory.items[index])
	

