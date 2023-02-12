extends PopupPanel

const _AMOUNT_MASK : String = "[x%d]"

var character : Character
var inventorySummary : InventorySummary


func _ready() -> void:
	$itemList/itemMenu.set_item_submenu(0, "partyMenu")


func _on_about_to_popup() -> void:
	character = GameManager.player
	
	$itemList.visible = !character.inventory.items.is_empty()
	$lblNoItems.visible = character.inventory.items.is_empty()
	
	var currentIndex = 0
	if !$itemList.get_selected_items().is_empty():
		currentIndex = $itemList.get_selected_items()[0]
	
	$itemList/itemMenu.hide()
	Signals.emit_signal("guiHidePartyMenu")
	$itemList.clear()
	
	inventorySummary = InventorySummary.new(character.inventory.items)
	
	for itemSummary in inventorySummary.summary:
		var itemName = itemSummary.name.substr(0, 14)
		
		var prefix = ""
		for i in range((14 - itemName.length()) / 2):
			prefix += ' '
		itemName = prefix + itemName
		
		for i in range(14 - itemName.length()):
			itemName += ' '
		
		$itemList.add_item((itemName + _AMOUNT_MASK) % itemSummary.amount)
	
	visible = true
	
	if currentIndex >= $itemList.get_item_count():
		currentIndex -= 1
	
	itemFocus(currentIndex)


func itemFocus(index : int) -> void:
	$itemList.grab_focus()
	if $itemList.item_count > 0:
		$itemList.select(index)


func _on_itemList_item_activated(index : int) -> void:
	var menuPosition = Vector2(position) + Vector2((index % 4) * 150 + 105, floor(index / 4) * 51 + 35)
	
	$itemList/itemMenu.position = menuPosition
	$itemList/itemMenu.popup()
	$itemList/itemMenu.grab_focus()
	$itemList/itemMenu.set_focused_item(0)


# TODO party
func _on_itemMenu_id_pressed(id : int) -> void:
	match id:
		0:
			return
		
		1:
			Signals.characterDroppedItem.emit(
				character,
				inventorySummary.summary[$itemList.get_selected_items()[0]].item)
			
			$itemList/itemMenu.hide()
			_on_about_to_popup()
		
		_:
			$itemList/itemMenu.hide()


func _on_party_menu_index_pressed(index: int) -> void:
	print(index)
	
	var item = inventorySummary.summary[$itemList.get_selected_items()[0]].item
	Signals.characterUsedItem.emit(
		character,
		GameManager.party if (item.targetType > Enums.MoveTargetType.FOE) else [GameManager.party[index]],
		item)
	
	$itemList/itemMenu.hide()
	_on_about_to_popup()

