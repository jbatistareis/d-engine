extends MarginContainer

const _AMOUNT_MASK : String = "[x%d]"

var character : Character
var inventorySummary : InventorySummary


func _ready() -> void:
	Signals.connect("battleInventoryShow",Callable(self,"showWindow"))
	Signals.connect("guiCancel",Callable(self,"hide"))


func showWindow(character : Character) -> void:
	$ItemList.clear()
	self.character = character
	
	$ItemList.visible = !character.inventory.items.is_empty()
	$lblNoItems.visible = character.inventory.items.is_empty()
	
	inventorySummary = InventorySummary.new(character.inventory.items)
	
	for itemSummary in inventorySummary.summary:
		var itemName = itemSummary.name.substr(0, 14)
		
		var prefix = ""
		for i in range((14 - itemName.length()) / 2):
			prefix += ' '
		itemName = prefix + itemName
		
		for i in range(14 - itemName.length()):
			itemName += ' '
		
		$ItemList.add_item((itemName + _AMOUNT_MASK) % itemSummary.amount)
	
	visible = true
	$ItemList.grab_focus()
	if !$ItemList.items.is_empty():
		$ItemList.select(0)


func hide() -> void:
	if visible:
		visible = false
		Signals.emit_signal("battleShowCharacterMoves", character)


func _on_ItemList_item_activated(index):
	visible = false
	Signals.emit_signal("battleCursorShow", character, ItemMove.new(inventorySummary.summary[index].item))

