extends MarginContainer

const _AMOUNT_MASK : String = "[x%d]"

var character : Character
var inventorySummary : InventorySummary


func showWindow(character : Character) -> void:
	self.character = character
	
	if !Signals.guiCancel.is_connected(back):
		Signals.guiCancel.connect(back)
	
	if !Signals.guiCloseExploringMenu.is_connected(exit):
		Signals.guiCloseExploringMenu.connect(exit)
	
	$itemList.visible = !character.inventory.items.is_empty()
	$lblNoItems.visible = character.inventory.items.is_empty()
	
	$itemList.modulate = $itemList.modulate.lightened(1)
	$Panel.modulate = $Panel.modulate.lightened(1)
	
	var currentIndex = 0
	if !$itemList.get_selected_items().is_empty():
		currentIndex = $itemList.get_selected_items()[0]
	
	$itemMenu.hide()
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
	if !$itemList.items.is_empty():
		$itemList.select(index)


func back() -> void:
	if $itemMenu.visible && $"../partyMenu".visible:
		$itemMenu.modulate = $itemMenu.modulate.lightened(1)
		Signals.guiHidePartyMenu.emit()
	elif $itemMenu.visible && !$"../partyMenu".visible:
		$itemList.modulate = $itemList.modulate.lightened(1)
		$Panel.modulate = $Panel.modulate.lightened(1)
		$itemMenu.hide()
	elif !$itemMenu.visible && !$"../partyMenu".visible:
		exit()
		Signals.guiBack.emit()


func exit() -> void:
	Signals.guiCancel.disconnect(back)
	Signals.guiCloseExploringMenu.disconnect(exit)
	
	if Signals.guiPartyMenuPick.is_connected(partyPick):
		Signals.guiPartyMenuPick.disconnect(partyPick)
	
	Signals.guiHidePartyMenu.emit()
	
	$itemMenu.hide()
	visible = false


func _on_itemList_item_activated(index : int) -> void:
	$itemList.modulate = $itemList.modulate.darkened(0.25)
	$Panel.modulate = $Panel.modulate.darkened(0.25)
	$itemMenu.modulate = $itemMenu.modulate.lightened(1)
	
#	var item = inventorySummary.summary[index].item
	var menuPosition = $itemList.global_position + Vector2((index % 4) * 150 + 105, floor(index / 4) * 51 + 35)
	
	$itemMenu.position = menuPosition
	$itemMenu.popup()
	$itemMenu.grab_focus()
	$itemMenu.set_current_index(0)


# TODO party
func _on_itemMenu_id_pressed(id : int) -> void:
	match id:
		0:
			$itemMenu.modulate = $itemMenu.modulate.darkened(0.25)
			Signals.guiPartyMenuPick.connect(partyPick)
			Signals.guiPopupPartyMenu.emit($itemMenu.position + Vector2($itemMenu.size.x + 10, 0))
		
		1:
			Signals.characterDroppedItem.emit(
				character,
				inventorySummary.summary[$itemList.get_selected_items()[0]].item)
			showWindow(character)
		
		_:
			$itemList.modulate = $itemList.modulate.lightened(1)
			$Panel.modulate = $Panel.modulate.lightened(1)
			$itemMenu.hide()


func partyPick(id: int) -> void:
	Signals.guiPartyMenuPick.disconnect(partyPick)
	
	var item = inventorySummary.summary[$itemList.get_selected_items()[0]].item
	Signals.characterUsedItem.emit(
		character,
		GameManager.party if (item.targetType > Enums.MoveTargetType.FOE) else [GameManager.party[id]],
		item)
	
	showWindow(character)

