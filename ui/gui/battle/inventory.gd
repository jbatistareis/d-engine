extends MarginContainer

const _ITEM_TEXT : String = '%s[x%d]'

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
		$ItemList.add_item(_ITEM_TEXT % item.name.substr(0, 14))
	
	visible = true
	$ItemList.grab_focus()
	if !$ItemList.items.empty():
		$ItemList.select(0)


func hide() -> void:
	if visible:
		visible = false
		Signals.emit_signal("battleShowCharacterMoves", character)

