extends MarginContainer

var character : Character


func _ready() -> void:
	Signals.connect("guiCancel", self, "hide")
	Signals.connect("guiCloseExploringMenu", self, "exit")


func showWindow(character : Character) -> void:
	get_parent().unfocus()
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
		get_parent().focus()


func exit() -> void:
	if visible:
		visible = false


func _on_ItemList_item_activated(index: int) -> void:
	pass # Replace with function body.

