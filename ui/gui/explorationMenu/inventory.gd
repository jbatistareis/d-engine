extends PopupPanel

const _NAME_MASK : String = "%-20s [x%02d]"

var character : Character
var inventorySummary : InventorySummary


func _ready() -> void:
	$itemList/itemMenu.set_item_submenu(0, "partyMenu")


func _on_about_to_popup(onIndex : int = 0) -> void:
	character = GameManager.player
	
	$itemList.clear()
	
	$itemList.visible = !character.inventory.items.is_empty()
	$lblNoItems.visible = character.inventory.items.is_empty()
	
	if $lblNoItems.visible:
		return
	
	inventorySummary = InventorySummary.new(character.inventory.items)
	
	for itemSummary in inventorySummary.summary:
		$itemList.add_item(_NAME_MASK % [itemSummary.name.substr(0, 20), itemSummary.amount])
	
	$itemList.grab_focus()
	if $itemList.item_count > 0:
		$itemList.select(onIndex)
		_on_item_list_item_selected(onIndex)


func _on_item_list_item_activated(index : int) -> void:
	$itemList/itemMenu.position = position + Vector2i(size.x, 0)
	$itemList/itemMenu.popup()
	$itemList/itemMenu.set_focused_item(0)
	$itemList/itemMenu.grab_focus()


func previousIndex() -> int:
	if inventorySummary.summary[$itemList.get_selected_items()[0]].amount > 1:
		return $itemList.get_selected_items()[0]
	else:
		return max(0, $itemList.get_selected_items()[0] - 1)


func _on_itemMenu_id_pressed(id : int) -> void:
	match id:
		1:
			Signals.characterDroppedItem.emit(
				character,
				inventorySummary.summary[$itemList.get_selected_items()[0]].item)
			
			_on_about_to_popup(previousIndex())
			$itemList/itemMenu.hide()
		
		2:
			$itemList/itemMenu.hide()


func _on_party_menu_index_pressed(index: int) -> void:
	var item = inventorySummary.summary[$itemList.get_selected_items()[0]].item
	Signals.characterUsedItem.emit(
		character,
		GameManager.party if (item.targetType > Enums.MoveTargetType.FOE) else [GameManager.party[index]],
		item)
	
	$itemList/itemMenu/partyMenu.hide()
	$itemList/itemMenu.hide()
	
	_on_about_to_popup(previousIndex())


func _on_item_list_item_selected(index: int) -> void:
	Signals.permanentToast.emit(inventorySummary.summary[index].item.description)


func _on_popup_hide() -> void:
	Signals.hideToast.emit()


func _on_party_menu_about_to_popup() -> void:
	$itemList/itemMenu/partyMenu.position = $itemList/itemMenu.position + Vector2i($itemList/itemMenu.size.x, 0)

