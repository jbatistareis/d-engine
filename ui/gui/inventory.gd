extends PopupPanel

const _NAME_MASK : String = "%-15s [x%02d]"

var character : Character
var inventorySummary : InventorySummary


func _on_about_to_popup() -> void:
	character = GameManager.player
	
	$itemList.visible = !character.inventory.items.is_empty()
	$lblNoItems.visible = character.inventory.items.is_empty()
	
	$itemList.clear()
	
	inventorySummary = InventorySummary.new(character.inventory.items)
	
	for itemSummary in inventorySummary.summary:
		$itemList.add_item(_NAME_MASK % [itemSummary.name.substr(0, 15), itemSummary.amount])
	
	$itemList.grab_focus()
	if $itemList.item_count > 0:
		$itemList.select(0)


func _on_item_list_item_activated(index : int) -> void:
	var menuPosition = Vector2(position.x + size.x, position.y)
	
	$itemList/itemMenu.position = menuPosition
	$itemList/itemMenu.popup()
	$itemList/itemMenu.grab_focus()
	$itemList/itemMenu.set_focused_item(0)


func _on_itemMenu_id_pressed(id : int) -> void:
	match id:
		0:
			$itemList/partyMenu.position = Vector2(position.x + size.x, position.y)
			$itemList/partyMenu.popup()
		
		1:
			Signals.characterDroppedItem.emit(
				character,
				inventorySummary.summary[$itemList.get_selected_items()[0]].item)
			
			_on_about_to_popup()
		
		2:
			$itemList/itemMenu.hide()


func _on_party_menu_index_pressed(index: int) -> void:
	var item = inventorySummary.summary[$itemList.get_selected_items()[0]].item
	Signals.characterUsedItem.emit(
		character,
		GameManager.party if (item.targetType > Enums.MoveTargetType.FOE) else [GameManager.party[index]],
		item)
	
	_on_about_to_popup()


func _on_item_list_item_selected(index: int) -> void:
	Signals.permanentToast.emit(inventorySummary.summary[index].item.description)


func _on_popup_hide() -> void:
	Signals.hideToast.emit()

