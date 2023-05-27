extends MarginContainer

const _LABEL : String = "%s\n[x%d]"

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
		$ItemList.add_item(_LABEL % [itemSummary.name.substr(0, 14), itemSummary.amount])
	
	visible = true
	$ItemList.grab_focus()
	if !$ItemList.item_count == 0:
		$ItemList.select(0)
		Signals.battleMoveDescription.emit(inventorySummary.summary[0].item.description)


func hideWindow() -> void:
	if visible:
		visible = false
		Signals.battleAskedMove.emit(character)


func _on_ItemList_item_activated(index):
	visible = false
	Signals.battleCursorShow.emit(character, ItemMove.new(inventorySummary.summary[index].item))


func _on_item_list_item_selected(index: int) -> void:
	Signals.battleMoveDescription.emit(inventorySummary.summary[index].item.description)

