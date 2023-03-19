extends MarginContainer

const _AMOUNT_MASK : String = "[x%d]"

var character : Character
var inventorySummary : InventorySummary


func _ready() -> void:
	Signals.battleInventoryShow.connect(showWindow)
	Signals.guiCancel.connect(hideWindow)


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
	if !$ItemList.item_count == 0:
		$ItemList.select(0)


func hideWindow() -> void:
	if visible:
		visible = false
		Signals.battleShowCharacterMoves.emit(character)


func _on_ItemList_item_activated(index):
	visible = false
	Signals.battleCursorShow.emit(character, ItemMove.new(inventorySummary.summary[index].item))

