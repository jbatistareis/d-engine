extends MarginContainer

const _AMOUNT_MASK : String = "[x%d]"

var id : int
var character : Character
var inventorySummary : InventorySummary


func showWindow() -> void:
	Signals.connect("guiPartyMenuPick", self, "partyPick")
	Signals.connect("guiCancel", self, "back")
	Signals.connect("guiCloseExploringMenu", self, "exit")
	
	Signals.emit_signal("guiPopupPartyMenu", $"../menu/box/btnEquip".rect_global_position + Vector2($"../menu/box/btnEquip".rect_size.x + 10, 0))


func partyPick(id: int) -> void:
	self.id = id
	self.character = GameManager.party[id]
	
	$main/itemList.visible = !character.inventory.weapons.empty()
	$main/lblNoWeap.visible = character.inventory.weapons.empty()
	
	$main/itemList.modulate = $main/itemList.modulate.lightened(1)
	$Panel.modulate = $Panel.modulate.lightened(1)
	
	var currentIndex = 0
	if !$main/itemList.get_selected_items().empty():
		currentIndex = $main/itemList.get_selected_items()[0]
	
	$itemMenu.hide()
	Signals.emit_signal("guiHidePartyMenu")
	$main/itemList.clear()
	
	inventorySummary = InventorySummary.new(character)
	
	for itemSummary in inventorySummary.summary:
		var itemName = itemSummary.name.substr(0, 14)
		
		var prefix = ""
		for i in range((14 - itemName.length()) / 2):
			prefix += ' '
		itemName = prefix + itemName
		
		for i in range(14 - itemName.length()):
			itemName += ' '
		
		$main/itemList.add_item((itemName + _AMOUNT_MASK) % itemSummary.amount)
	
	visible = true
	
	if currentIndex >= $main/itemList.get_item_count():
		currentIndex -= 1
	
	itemFocus(currentIndex)


func itemFocus(index : int) -> void:
	$main/itemList.grab_focus()
	if !$main/itemList.items.empty():
		$main/itemList.select(index)


func back() -> void:
	if $itemMenu.visible && $partyMenu.visible:
		$itemMenu.modulate = $itemMenu.modulate.lightened(1)
		Signals.emit_signal("guiHidePartyMenu")
	elif $itemMenu.visible && !$partyMenu.visible:
		$main/itemList.modulate = $main/itemList.modulate.lightened(1)
		$Panel.modulate = $Panel.modulate.lightened(1)
		$itemMenu.hide()
	elif !$itemMenu.visible && !$"../partyMenu".visible:
		exit()
		Signals.emit_signal("guiBack")


func exit() -> void:
	Signals.disconnect("guiPartyMenuPick", self, "partyPick")
	Signals.disconnect("guiCancel", self, "back")
	Signals.disconnect("guiCloseExploringMenu", self, "exit")
	if Signals.is_connected("guiPartyMenuHidden", self, "back"):
		Signals.disconnect("guiPartyMenuHidden", self, "back")
	
	visible = false
	$itemMenu.hide()
	Signals.emit_signal("guiHidePartyMenu")


func _on_itemList_item_activated(index : int) -> void:
	$main/itemList.modulate = $main/itemList.modulate.darkened(0.25)
	$Panel.modulate = $Panel.modulate.darkened(0.25)
	$itemMenu.modulate = $itemMenu.modulate.lightened(1)
	
	var item = inventorySummary.summary[index].item
	var menuPosition = $main/itemList.rect_global_position + Vector2(index * 152, floor(index / 4) * 51) + Vector2(126, 30)
	
	$itemMenu.rect_position = menuPosition
	$itemMenu.popup()
	$itemMenu.grab_focus()
	$itemMenu.set_current_index(0)


# TODO party
func _on_itemMenu_id_pressed(id : int) -> void:
	var item = inventorySummary.summary[$main/itemList.get_selected_items()[0]].item
	
	match id:
		0:
			$itemMenu.modulate = $itemMenu.modulate.darkened(0.25)
			Signals.connect("guiPartyMenuPick", self, "partyPick")
			Signals.emit_signal("guiPopupPartyMenu", $itemMenu.rect_position + Vector2($itemMenu.rect_size.x + 10, 0))
		
		1:
			var inventoryIndex = character.inventory.items.bsearch_custom(item.shortName, EntityArrayHelper, 'shortNameFind')
			character.inventory.removeItem(inventoryIndex)
			$itemMenu.hide()
			partyPick(id)
		
		_:
			$main/itemList.modulate = $main/itemList.modulate.lightened(1)
			$Panel.modulate = $Panel.modulate.lightened(1)
			$itemMenu.hide()

